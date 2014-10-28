Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47368 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaJ1Mf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 08:35:58 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so9123816wiv.15
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 05:35:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
	<CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
	<CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>
	<CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com>
Date: Tue, 28 Oct 2014 13:35:57 +0100
Message-ID: <CAAfyv35G=9WyYxQZjt3EYfGC+u0z81ktXrO7LEUrADxKX3XDNA@mail.gmail.com> (sfid-20141028_133602_875974_541FA698)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: multipart/mixed; boundary=001a11c1b66a933aea05067ae306
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a11c1b66a933aea05067ae306
Content-Type: text/plain; charset=UTF-8

Hi Amitkumar,

On Thu, Oct 23, 2014 at 2:40 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
>>> I tried to capture logs but when enable DYNAMIC_DEBUG I cannot
>>> reproduce issue (running test > 30 minutes without allocation
>>> failure).
>
> Thanks for the testing. Yes. Sometimes timing issues won't get reproduced with debug messages enabled.
>
>>Any update on this? Should I provide some other logs?
>
> What's the size of Rx data packets? Is the Rx data AMSDU aggregated?(You can check if "if (rx_pkt_type == PKT_TYPE_AMSDU)" check is passed in mwifiex code) If so, disable AMSDU option in AP and try to reproduce the issue.
Size of Rx data packets are : pkt type == 2, size - 1574bytes + BAR
pkt type, size - 34bytes. AMSDU isn't enabled on AP (verified by
adding debug message in mwifiex_process_sta_rx_packet()).
>
> As you suspected earlier, we might have missed to free skbs allocated for Rx data which leads to SKB allocation failure. There is very less probability for this. But we can try below experiment.
>
> 1) I observed that debug variable "adapter->rx_pending" doesn;t get decremented when packet is submitted to kernel. Add below code change(valid only for AMSDU disabled case. Because multiple packets are submitted to kernel when AMSDU is enabled)
>
> ----------
> --- a/drivers/net/wireless/mwifiex/util.c
> +++ b/drivers/net/wireless/mwifiex/util.c
> @@ -218,6 +218,7 @@ int mwifiex_recv_packet(struct mwifiex_private *priv, struct sk_buff *skb)
>
>         priv->stats.rx_bytes += skb->len;
>         priv->stats.rx_packets++;
> +       atomic_dec(&priv->adapter->rx_pending);
>         if (in_interrupt())
>                 netif_rx(skb);
> ----------
OK, patch applied.
>
> 2) Add BUG_ON when first time SKB allocation is failed and print "rx_pending". If it's a huge number, we have missed freeing allocated SKB.
[  167.624452] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed, rx_pending:26893
[  167.632885] ------------[ cut here ]------------
[  167.637743] Kernel BUG at bf8a22ae [verbose debug info unavailable]
so number seems to be huge and we seems miss free allocated skb.

I did some hacks to code which shows how many packets are received
between 2 BAR packets + I print every 500ms rx_pending packets (when
packet is received) and
also when packet is send to kernel. I also update counter how many
packets after reordering are sent to kernel. Log:
[   71.973800] usb 1-1: rx_pending:11
[   72.077308] usb 1-1: rx_pending kernel:10
[   72.477546] usb 1-1: rx_pending:868
[   72.587877] usb 1-1: rx_pending kernel:1096
[   72.818041] usb 1-1: Received between 2 BAR:6275
[   72.823127] usb 1-1: Networking send size:6271
[   72.987375] usb 1-1: rx_pending:1940
[   73.097504] usb 1-1: rx_pending kernel:2159
[   73.431973] usb 1-1: Received between 2 BAR:1602
[   73.437106] usb 1-1: Networking send size:1608
[   73.497381] usb 1-1: rx_pending:2983
[   73.608315] usb 1-1: rx_pending kernel:3091
[   74.007379] usb 1-1: rx_pending:3767
[   74.117879] usb 1-1: rx_pending kernel:3998
[   74.517375] usb 1-1: rx_pending:4854
[   74.543168] usb 1-1: Received between 2 BAR:3152
[   74.548371] usb 1-1: Networking send size:3152
[   74.627509] usb 1-1: rx_pending kernel:5062
[   74.743362] usb 1-1: Received between 2 BAR:495
[   74.748483] usb 1-1: Networking send size:494
[   75.027523] usb 1-1: rx_pending:5872
[   75.137961] usb 1-1: rx_pending kernel:6106
[   75.537485] usb 1-1: rx_pending:6959
[   75.647934] usb 1-1: rx_pending kernel:7188
[   75.656273] usb 1-1: Received between 2 BAR:2383
[   75.661528] usb 1-1: Networking send size:2382
[   76.047441] usb 1-1: rx_pending:8004
[   76.157712] usb 1-1: rx_pending kernel:8240
[   76.557547] usb 1-1: rx_pending:9095
[   76.667991] usb 1-1: rx_pending kernel:9326
[   76.769662] usb 1-1: Received between 2 BAR:2918
[   76.775047] usb 1-1: Networking send size:2914
[   77.067491] usb 1-1: rx_pending:10155
[   77.177524] usb 1-1: rx_pending kernel:10383
[   77.577547] usb 1-1: rx_pending:11237
[   77.687859] usb 1-1: rx_pending kernel:11461
[   78.087401] usb 1-1: rx_pending:12304
[   78.197992] usb 1-1: rx_pending kernel:12539
[   78.597442] usb 1-1: rx_pending:13391
[   78.707786] usb 1-1: rx_pending kernel:13628
[   79.107487] usb 1-1: rx_pending:14469
[   79.217812] usb 1-1: rx_pending kernel:14704
[   79.617528] usb 1-1: rx_pending:15555
[   79.727734] usb 1-1: rx_pending kernel:15781
[   80.127486] usb 1-1: rx_pending:16624
[   80.237756] usb 1-1: rx_pending kernel:16855
[   80.637423] usb 1-1: rx_pending:17699
[   80.747868] usb 1-1: rx_pending kernel:17926
[   81.147446] usb 1-1: rx_pending:18769
[   81.257800] usb 1-1: rx_pending kernel:18995
[   81.657399] usb 1-1: rx_pending:19851
[   81.767785] usb 1-1: rx_pending kernel:20083
[   82.167341] usb 1-1: rx_pending:20938
[   82.278005] usb 1-1: rx_pending kernel:21174
[   82.677527] usb 1-1: rx_pending:22025
[   82.787508] usb 1-1: rx_pending kernel:22246
[   83.187390] usb 1-1: rx_pending:23103
[   83.297690] usb 1-1: rx_pending kernel:23326
[   83.697376] usb 1-1: rx_pending:24182
[   83.807711] usb 1-1: rx_pending kernel:24404
[   84.207487] usb 1-1: rx_pending:25236
[   84.317747] usb 1-1: rx_pending kernel:25466
[   84.717378] usb 1-1: rx_pending:26308
[   84.827806] usb 1-1: rx_pending kernel:26522
[   85.070931] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27017
[   85.079788] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27019
[   85.088424] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27020
[   85.097029] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27020
[   85.105845] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27022
[   85.114468] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
failed - rx_pending:27023
[   85.337391] usb 1-1: rx_pending kernel:22327
[   85.400153] usb 1-1: Received between 2 BAR:27875
[   85.405135] usb 1-1: Networking send size:27881
[   85.766194] usb 1-1: Received between 2 BAR:7781
[   85.771152] usb 1-1: Networking send size:7781
[   85.847374] usb 1-1: rx_pending kernel:11681
[   86.112809] usb 1-1: Received between 2 BAR:7263
[   86.117755] usb 1-1: Networking send size:7262
[   86.357378] usb 1-1: rx_pending kernel:827

According log it seems rx_pending is slowly increasing until
allocation fails. Code hacks are attached.

>
> 3) Also, get rx_pending info when Rx traffic works fine with 40M bandwidth option.
when -b40 is set then IMO 11n reordering isn't applied. I added some
debug code to mwifiex_11n_rx_reorder_pkt()
.. snip ..
tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 if (!tbl) {
.. snip ..

is always true (!tbl) so rx_pending after session is 0.

>
> Btw, could you move to the firmware image (14.68.29.p38)
> shared recently?
Tested with  14.68.29.p38 FW version. Issue still reproducible.
>
> By any means(redirecting the log to serial console etc.), could you please capture and share kernel trace logs when system becomes unresponsive. It may give some clue and help us debug further.
As I wrote earlier with DYNAMIC_DEBUG I cannot reproduce issue. Maybe
when we drop some debug code (received packet over USB) issue can be
reproducible again, but it's just guess.
>
> Best Regards,
> Amit

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

--001a11c1b66a933aea05067ae306
Content-Type: text/plain; charset=US-ASCII; name="patch.txt"
Content-Disposition: attachment; filename="patch.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_i1t8k1up0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvMTFuX3J4cmVvcmRlci5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8xMW5fcnhyZW9yZGVyLmMKaW5kZXggNWU3
OTZmOC4uZjZhOGQwZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8x
MW5fcnhyZW9yZGVyLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC8xMW5fcnhy
ZW9yZGVyLmMKQEAgLTI2LDYgKzI2LDcgQEAKICNpbmNsdWRlICIxMW4uaCIKICNpbmNsdWRlICIx
MW5fcnhyZW9yZGVyLmgiCiAKK3N0YXRpYyBpbnQgcGt0X3NlbmQgPSAwOwogLyoKICAqIFRoaXMg
ZnVuY3Rpb24gZGlzcGF0Y2hlcyBhbGwgcGFja2V0cyBpbiB0aGUgUnggcmVvcmRlciB0YWJsZSB1
bnRpbCB0aGUKICAqIHN0YXJ0IHdpbmRvdy4KQEAgLTM2LDcgKzM3LDcgQEAKICAqLwogc3RhdGlj
IHZvaWQKIG13aWZpZXhfMTFuX2Rpc3BhdGNoX3BrdChzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpw
cml2LAotCQkJIHN0cnVjdCBtd2lmaWV4X3J4X3Jlb3JkZXJfdGJsICp0YmwsIGludCBzdGFydF93
aW4pCisJCQkgc3RydWN0IG13aWZpZXhfcnhfcmVvcmRlcl90YmwgKnRibCwgaW50IHN0YXJ0X3dp
biwgaW50ICpzZW5kX3NpemUpCiB7CiAJaW50IHBrdF90b19zZW5kLCBpOwogCXZvaWQgKnJ4X3Rt
cF9wdHI7CkBAIC00NSw2ICs0Niw3IEBAIG13aWZpZXhfMTFuX2Rpc3BhdGNoX3BrdChzdHJ1Y3Qg
bXdpZmlleF9wcml2YXRlICpwcml2LAogCXBrdF90b19zZW5kID0gKHN0YXJ0X3dpbiA+IHRibC0+
c3RhcnRfd2luKSA/CiAJCSAgICAgIG1pbigoc3RhcnRfd2luIC0gdGJsLT5zdGFydF93aW4pLCB0
YmwtPndpbl9zaXplKSA6CiAJCSAgICAgIHRibC0+d2luX3NpemU7CisvLwlwcl9pbmZvKCIlcyAt
IHBrdF90b19zZW5kOiVkXG4iLCBfX2Z1bmNfXywgcGt0X3RvX3NlbmQpOwogCiAJZm9yIChpID0g
MDsgaSA8IHBrdF90b19zZW5kOyArK2kpIHsKIAkJc3Bpbl9sb2NrX2lycXNhdmUoJnByaXYtPnJ4
X3BrdF9sb2NrLCBmbGFncyk7CkBAIC01Nyw4ICs1OSwxMSBAQCBtd2lmaWV4XzExbl9kaXNwYXRj
aF9wa3Qoc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKIAkJaWYgKHJ4X3RtcF9wdHIpIHsK
IAkJCWlmIChwcml2LT5ic3Nfcm9sZSA9PSBNV0lGSUVYX0JTU19ST0xFX1VBUCkKIAkJCQltd2lm
aWV4X2hhbmRsZV91YXBfcnhfZm9yd2FyZChwcml2LCByeF90bXBfcHRyKTsKLQkJCWVsc2UKKwkJ
CWVsc2UgewogCQkJCW13aWZpZXhfcHJvY2Vzc19yeF9wYWNrZXQocHJpdiwgcnhfdG1wX3B0cik7
CisJCQkJaWYgKHNlbmRfc2l6ZSkKKwkJCQkJKnNlbmRfc2l6ZSArPSAxOworCQkJfQogCQl9CiAJ
fQogCkBAIC04Niw3ICs5MSw3IEBAIG13aWZpZXhfMTFuX2Rpc3BhdGNoX3BrdChzdHJ1Y3QgbXdp
ZmlleF9wcml2YXRlICpwcml2LAogICovCiBzdGF0aWMgdm9pZAogbXdpZmlleF8xMW5fc2Nhbl9h
bmRfZGlzcGF0Y2goc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKLQkJCSAgICAgIHN0cnVj
dCBtd2lmaWV4X3J4X3Jlb3JkZXJfdGJsICp0YmwpCisJCQkgICAgICBzdHJ1Y3QgbXdpZmlleF9y
eF9yZW9yZGVyX3RibCAqdGJsLCBpbnQgKnNlbmRfc2l6ZSkKIHsKIAlpbnQgaSwgaiwgeGNoZzsK
IAl2b2lkICpyeF90bXBfcHRyOwpAQCAtMTA0LDggKzEwOSwxMCBAQCBtd2lmaWV4XzExbl9zY2Fu
X2FuZF9kaXNwYXRjaChzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpwcml2LAogCiAJCWlmIChwcml2
LT5ic3Nfcm9sZSA9PSBNV0lGSUVYX0JTU19ST0xFX1VBUCkKIAkJCW13aWZpZXhfaGFuZGxlX3Vh
cF9yeF9mb3J3YXJkKHByaXYsIHJ4X3RtcF9wdHIpOwotCQllbHNlCisJCWVsc2UgewogCQkJbXdp
ZmlleF9wcm9jZXNzX3J4X3BhY2tldChwcml2LCByeF90bXBfcHRyKTsKKwkJCSpzZW5kX3NpemUg
Kz0gMTsKKwkJfQogCX0KIAogCXNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5yeF9wa3RfbG9jaywg
ZmxhZ3MpOwpAQCAtMTQwLDcgKzE0Nyw3IEBAIG13aWZpZXhfZGVsX3J4X3Jlb3JkZXJfZW50cnko
c3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKIAkJcmV0dXJuOwogCiAJbXdpZmlleF8xMW5f
ZGlzcGF0Y2hfcGt0KHByaXYsIHRibCwgKHRibC0+c3RhcnRfd2luICsgdGJsLT53aW5fc2l6ZSkg
JgotCQkJCQkgICAgKE1BWF9USURfVkFMVUUgLSAxKSk7CisJCQkJCSAgICAoTUFYX1RJRF9WQUxV
RSAtIDEpLCBOVUxMKTsKIAogCWRlbF90aW1lcigmdGJsLT50aW1lcl9jb250ZXh0LnRpbWVyKTsK
IApAQCAtMjM4LDcgKzI0NSw3IEBAIG13aWZpZXhfZmx1c2hfZGF0YSh1bnNpZ25lZCBsb25nIGNv
bnRleHQpCiAJZGV2X2RiZyhjdHgtPnByaXYtPmFkYXB0ZXItPmRldiwgImluZm86IGZsdXNoIGRh
dGEgJWRcbiIsIHN0YXJ0X3dpbik7CiAJbXdpZmlleF8xMW5fZGlzcGF0Y2hfcGt0KGN0eC0+cHJp
diwgY3R4LT5wdHIsCiAJCQkJIChjdHgtPnB0ci0+c3RhcnRfd2luICsgc3RhcnRfd2luICsgMSkg
JgotCQkJCSAoTUFYX1RJRF9WQUxVRSAtIDEpKTsKKwkJCQkgKE1BWF9USURfVkFMVUUgLSAxKSwg
TlVMTCk7CiB9CiAKIC8qCkBAIC0yNjcsNyArMjc0LDcgQEAgbXdpZmlleF8xMW5fY3JlYXRlX3J4
X3Jlb3JkZXJfdGJsKHN0cnVjdCBtd2lmaWV4X3ByaXZhdGUgKnByaXYsIHU4ICp0YSwKIAkgKi8K
IAl0YmwgPSBtd2lmaWV4XzExbl9nZXRfcnhfcmVvcmRlcl90YmwocHJpdiwgdGlkLCB0YSk7CiAJ
aWYgKHRibCkgewotCQltd2lmaWV4XzExbl9kaXNwYXRjaF9wa3QocHJpdiwgdGJsLCBzZXFfbnVt
KTsKKwkJbXdpZmlleF8xMW5fZGlzcGF0Y2hfcGt0KHByaXYsIHRibCwgc2VxX251bSwgTlVMTCk7
CiAJCXJldHVybjsKIAl9CiAJLyogaWYgIXRibCB0aGVuIGNyZWF0ZSBvbmUgKi8KQEAgLTQzNCwx
MSArNDQxLDE1IEBAIGludCBtd2lmaWV4XzExbl9yeF9yZW9yZGVyX3BrdChzdHJ1Y3QgbXdpZmll
eF9wcml2YXRlICpwcml2LAogCiAJdGJsID0gbXdpZmlleF8xMW5fZ2V0X3J4X3Jlb3JkZXJfdGJs
KHByaXYsIHRpZCwgdGEpOwogCWlmICghdGJsKSB7CisJCXByX2luZm8oIiF0YmxcbiIpOwogCQlp
ZiAocGt0X3R5cGUgIT0gUEtUX1RZUEVfQkFSKSB7CiAJCQlpZiAocHJpdi0+YnNzX3JvbGUgPT0g
TVdJRklFWF9CU1NfUk9MRV9VQVApCiAJCQkJbXdpZmlleF9oYW5kbGVfdWFwX3J4X2ZvcndhcmQo
cHJpdiwgcGF5bG9hZCk7CiAJCQllbHNlCiAJCQkJbXdpZmlleF9wcm9jZXNzX3J4X3BhY2tldChw
cml2LCBwYXlsb2FkKTsKKwkJfSBlbHNlIHsKKwkJCS8vIG1pc3NpbmcgZnJlZSAobWF5YmUgYWxz
byByeF9wZW5kaW5nKQorCQkJZGV2X2tmcmVlX3NrYl9hbnkocGF5bG9hZCk7CiAJCX0KIAkJcmV0
dXJuIDA7CiAJfQpAQCAtNDg1LDcgKzQ5Niw3IEBAIGludCBtd2lmaWV4XzExbl9yeF9yZW9yZGVy
X3BrdChzdHJ1Y3QgbXdpZmlleF9wcml2YXRlICpwcml2LAogCQkJc3RhcnRfd2luID0gKGVuZF93
aW4gLSB3aW5fc2l6ZSkgKyAxOwogCQllbHNlCiAJCQlzdGFydF93aW4gPSAoTUFYX1RJRF9WQUxV
RSAtICh3aW5fc2l6ZSAtIHNlcV9udW0pKSArIDE7Ci0JCW13aWZpZXhfMTFuX2Rpc3BhdGNoX3Br
dChwcml2LCB0YmwsIHN0YXJ0X3dpbik7CisJCW13aWZpZXhfMTFuX2Rpc3BhdGNoX3BrdChwcml2
LCB0YmwsIHN0YXJ0X3dpbiwgJnBrdF9zZW5kKTsKIAl9CiAKIAlpZiAocGt0X3R5cGUgIT0gUEtU
X1RZUEVfQkFSKSB7CkBAIC00OTgsMTMgKzUwOSwxNiBAQCBpbnQgbXdpZmlleF8xMW5fcnhfcmVv
cmRlcl9wa3Qoc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKIAkJCXJldHVybiAtMTsKIAog
CQl0YmwtPnJ4X3Jlb3JkZXJfcHRyW3BrdF9pbmRleF0gPSBwYXlsb2FkOworCX0gZWxzZSBpZiAo
cGt0X3R5cGUgPT0gUEtUX1RZUEVfQkFSKSB7CisJCWRldl9pbmZvKHByaXYtPmFkYXB0ZXItPmRl
diwgIk5ldHdvcmtpbmcgc2VuZCBzaXplOiVkXG4iLCBwa3Rfc2VuZCk7CisJCXBrdF9zZW5kID0g
MDsKIAl9CiAKIAkvKgogCSAqIERpc3BhdGNoIGFsbCBwYWNrZXRzIHNlcXVlbnRpYWxseSBmcm9t
IHN0YXJ0X3dpbiB1bnRpbCBhCiAJICogaG9sZSBpcyBmb3VuZCBhbmQgYWRqdXN0IHRoZSBzdGFy
dF93aW4gYXBwcm9wcmlhdGVseQogCSAqLwotCW13aWZpZXhfMTFuX3NjYW5fYW5kX2Rpc3BhdGNo
KHByaXYsIHRibCk7CisJbXdpZmlleF8xMW5fc2Nhbl9hbmRfZGlzcGF0Y2gocHJpdiwgdGJsLCAm
cGt0X3NlbmQpOwogCiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9td2lmaWV4L3N0YV9yeC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zdGFf
cnguYwppbmRleCBiNWMxMDk1Li5iYzFjMGQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9td2lmaWV4L3N0YV9yeC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgv
c3RhX3J4LmMKQEAgLTEyMiw2ICsxMjIsNyBAQCBpbnQgbXdpZmlleF9wcm9jZXNzX3N0YV9yeF9w
YWNrZXQoc3RydWN0IG13aWZpZXhfcHJpdmF0ZSAqcHJpdiwKIAlzdHJ1Y3QgcnhfcGFja2V0X2hk
ciAqcnhfcGt0X2hkcjsKIAl1OCB0YVtFVEhfQUxFTl07CiAJdTE2IHJ4X3BrdF90eXBlLCByeF9w
a3Rfb2Zmc2V0LCByeF9wa3RfbGVuZ3RoLCBzZXFfbnVtOworCXN0YXRpYyBpbnQgcGt0c19yZWNl
aXZlZCA9IDA7CiAKIAlsb2NhbF9yeF9wZCA9IChzdHJ1Y3QgcnhwZCAqKSAoc2tiLT5kYXRhKTsK
IAlyeF9wa3RfdHlwZSA9IGxlMTZfdG9fY3B1KGxvY2FsX3J4X3BkLT5yeF9wa3RfdHlwZSk7CkBA
IC0xNDYsNiArMTQ3LDcgQEAgaW50IG13aWZpZXhfcHJvY2Vzc19zdGFfcnhfcGFja2V0KHN0cnVj
dCBtd2lmaWV4X3ByaXZhdGUgKnByaXYsCiAJfQogCiAJaWYgKHJ4X3BrdF90eXBlID09IFBLVF9U
WVBFX0FNU0RVKSB7CisJCXByX2luZm8oIkFNU0RVXG4iKTsKIAkJc3RydWN0IHNrX2J1ZmZfaGVh
ZCBsaXN0OwogCQlzdHJ1Y3Qgc2tfYnVmZiAqcnhfc2tiOwogCkBAIC0xNjgsNiArMTcwLDcgQEAg
aW50IG13aWZpZXhfcHJvY2Vzc19zdGFfcnhfcGFja2V0KHN0cnVjdCBtd2lmaWV4X3ByaXZhdGUg
KnByaXYsCiAJCXJldCA9IG13aWZpZXhfcHJvY2Vzc19tZ210X3BhY2tldChwcml2LCBza2IpOwog
CQlpZiAocmV0KQogCQkJZGV2X2VycihhZGFwdGVyLT5kZXYsICJSeCBvZiBtZ210IHBhY2tldCBm
YWlsZWQiKTsKKwkJYXRvbWljX2RlYygmcHJpdi0+YWRhcHRlci0+cnhfcGVuZGluZyk7CiAJCWRl
dl9rZnJlZV9za2JfYW55KHNrYik7CiAJCXJldHVybiByZXQ7CiAJfQpAQCAtMTkxLDEwICsxOTQs
MTkgQEAgaW50IG13aWZpZXhfcHJvY2Vzc19zdGFfcnhfcGFja2V0KHN0cnVjdCBtd2lmaWV4X3By
aXZhdGUgKnByaXYsCiAJCSAgICAgICBFVEhfQUxFTik7CiAJfQogCisJaWYgKHJ4X3BrdF90eXBl
ICE9IFBLVF9UWVBFX0JBUiAmJiBza2ItPmxlbiA+IDE1MDApIHsKKwkJCXBrdHNfcmVjZWl2ZWQr
KzsKKwl9CisKKwlpZiAocnhfcGt0X3R5cGUgPT0gUEtUX1RZUEVfQkFSKSB7CisJCWRldl9pbmZv
KHByaXYtPmFkYXB0ZXItPmRldiwgIlJlY2VpdmVkIGJldHdlZW4gMiBCQVI6JWRcbiIsIHBrdHNf
cmVjZWl2ZWQpOworCQlwa3RzX3JlY2VpdmVkID0gMDsKKwl9CiAJLyogUmVvcmRlciBhbmQgc2Vu
ZCB0byBPUyAqLwogCXJldCA9IG13aWZpZXhfMTFuX3J4X3Jlb3JkZXJfcGt0KHByaXYsIHNlcV9u
dW0sIGxvY2FsX3J4X3BkLT5wcmlvcml0eSwKIAkJCQkJIHRhLCAodTgpIHJ4X3BrdF90eXBlLCBz
a2IpOwogCisKIAlpZiAocmV0IHx8IChyeF9wa3RfdHlwZSA9PSBQS1RfVFlQRV9CQVIpKSB7CiAJ
CWlmIChhZGFwdGVyLT5pZl9vcHMuZGF0YV9jb21wbGV0ZSkKIAkJCWFkYXB0ZXItPmlmX29wcy5k
YXRhX2NvbXBsZXRlKGFkYXB0ZXIsIHNrYik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9td2lmaWV4L3VzYi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC91c2IuYwpp
bmRleCA3ZDlkMTBiLi45NTlkYWVkIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9t
d2lmaWV4L3VzYi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvdXNiLmMKQEAg
LTM4LDYgKzM4LDcgQEAgc3RhdGljIHN0cnVjdCB1c2JfZGV2aWNlX2lkIG13aWZpZXhfdXNiX3Rh
YmxlW10gPSB7CiAKIE1PRFVMRV9ERVZJQ0VfVEFCTEUodXNiLCBtd2lmaWV4X3VzYl90YWJsZSk7
CiAKK3Vuc2lnbmVkIGxvbmcgdGltZW91dCA9IDA7CiAvKiBJbmRpY2F0ZSBpZiBsb2FkIEZXIGlu
IE1GRyAodGVzdGluZykgbW9kZSAqLwogc3RhdGljIGludCBtZmdfbW9kZSA9IDA7CiAKQEAgLTE3
OCw4ICsxNzksMTQgQEAgc3RhdGljIHZvaWQgbXdpZmlleF91c2JfcnhfY29tcGxldGUoc3RydWN0
IHVyYiAqdXJiKQogCQlhdG9taWNfaW5jKCZhZGFwdGVyLT5yeF9wZW5kaW5nKTsKIAkJc3RhdHVz
ID0gbXdpZmlleF91c2JfcmVjdihhZGFwdGVyLCBza2IsIGNvbnRleHQtPmVwKTsKIAorCQlpZiAo
dGltZV9hZnRlcihqaWZmaWVzLCB0aW1lb3V0KSkgeworCQkJZGV2X2luZm8oYWRhcHRlci0+ZGV2
LCAicnhfcGVuZGluZzolZFxuIiwgYXRvbWljX3JlYWQoJmFkYXB0ZXItPnJ4X3BlbmRpbmcpKTsK
KwkJCXRpbWVvdXQgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg1MDApOworCQl9CisKIAkJ
ZGV2X2RiZyhhZGFwdGVyLT5kZXYsICJpbmZvOiByZWN2X2xlbmd0aD0lZCwgc3RhdHVzPSVkXG4i
LAogCQkJcmVjdl9sZW5ndGgsIHN0YXR1cyk7CisKIAkJaWYgKHN0YXR1cyA9PSAtRUlOUFJPR1JF
U1MpIHsKIAkJCXF1ZXVlX3dvcmsoYWRhcHRlci0+d29ya3F1ZXVlLCAmYWRhcHRlci0+bWFpbl93
b3JrKTsKIApAQCAtMjU5LDcgKzI2Niw3IEBAIHN0YXRpYyBpbnQgbXdpZmlleF91c2Jfc3VibWl0
X3J4X3VyYihzdHJ1Y3QgdXJiX2NvbnRleHQgKmN0eCwgaW50IHNpemUpCiAJCWN0eC0+c2tiID0g
ZGV2X2FsbG9jX3NrYihzaXplKTsKIAkJaWYgKCFjdHgtPnNrYikgewogCQkJZGV2X2VycihhZGFw
dGVyLT5kZXYsCi0JCQkJIiVzOiBkZXZfYWxsb2Nfc2tiIGZhaWxlZFxuIiwgX19mdW5jX18pOwor
CQkJCSIlczogZGV2X2FsbG9jX3NrYiBmYWlsZWQgLSByeF9wZW5kaW5nOiVkXG4iLCBfX2Z1bmNf
XywgYXRvbWljX3JlYWQoJmFkYXB0ZXItPnJ4X3BlbmRpbmcpKTsKIAkJCXJldHVybiAtRU5PTUVN
OwogCQl9CiAJfQpAQCAtMzQ0LDYgKzM1MSw3IEBAIHN0YXRpYyBpbnQgbXdpZmlleF91c2JfcHJv
YmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYsCiAJYmNkX3VzYiA9IGxlMTZfdG9fY3B1KHVk
ZXYtPmRlc2NyaXB0b3IuYmNkVVNCKTsKIAlwcl9kZWJ1ZygiaW5mbzogVklEL1BJRCA9ICVYLyVY
LCBCb290MiB2ZXJzaW9uID0gJVhcbiIsCiAJCSBpZF92ZW5kb3IsIGlkX3Byb2R1Y3QsIGJjZF9k
ZXZpY2UpOworCXRpbWVvdXQgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcygxMDAwKTsKIAog
CS8qIFBJRF8xIGlzIHVzZWQgZm9yIGZpcm13YXJlIGRvd25sb2FkaW5nIG9ubHkgKi8KIAlpZiAo
aWRfcHJvZHVjdCA9PSBVU0I4Nzk3X1BJRF8xKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbXdpZmlleC91dGlsLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3V0aWwu
YwppbmRleCAyMTU1Mzk3Li5iMThlZTEzIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9td2lmaWV4L3V0aWwuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3V0aWwu
YwpAQCAtMjUsNiArMjUsNyBAQAogI2luY2x1ZGUgIndtbS5oIgogI2luY2x1ZGUgIjExbi5oIgog
Cit1bnNpZ25lZCBsb25nIHRpbWVvdXQgPSAwOwogLyoKICAqIEZpcm13YXJlIGluaXRpYWxpemF0
aW9uIGNvbXBsZXRlIGNhbGxiYWNrIGhhbmRsZXIuCiAgKgpAQCAtMTk1LDYgKzE5Niw5IEBAIGlu
dCBtd2lmaWV4X3JlY3ZfcGFja2V0KHN0cnVjdCBtd2lmaWV4X3ByaXZhdGUgKnByaXYsIHN0cnVj
dCBza19idWZmICpza2IpCiAJc2tiLT5wcm90b2NvbCA9IGV0aF90eXBlX3RyYW5zKHNrYiwgcHJp
di0+bmV0ZGV2KTsKIAlza2ItPmlwX3N1bW1lZCA9IENIRUNLU1VNX05PTkU7CiAKKwlpZiAodGlt
ZW91dCA9PSAwKQorCQl0aW1lb3V0ID0gamlmZmllczsKKwogCS8qIFRoaXMgaXMgcmVxdWlyZWQg
b25seSBpbiBjYXNlIG9mIDExbiBhbmQgVVNCIGFzIHdlIGFsbG9jCiAJICogYSBidWZmZXIgb2Yg
NEsgb25seSBpZiBpdHMgMTFOICh0byBiZSBhYmxlIHRvIHJlY2VpdmUgNEsKIAkgKiBBTVNEVSBw
YWNrZXRzKS4gSW4gY2FzZSBvZiBTRCB3ZSBhbGxvY2F0ZSBidWZmZXJzIGJhc2VkCkBAIC0yMTgs
NiArMjIyLDEyIEBAIGludCBtd2lmaWV4X3JlY3ZfcGFja2V0KHN0cnVjdCBtd2lmaWV4X3ByaXZh
dGUgKnByaXYsIHN0cnVjdCBza19idWZmICpza2IpCiAKIAlwcml2LT5zdGF0cy5yeF9ieXRlcyAr
PSBza2ItPmxlbjsKIAlwcml2LT5zdGF0cy5yeF9wYWNrZXRzKys7CisJYXRvbWljX2RlYygmcHJp
di0+YWRhcHRlci0+cnhfcGVuZGluZyk7CisJaWYgKHRpbWVfYWZ0ZXIoamlmZmllcywgdGltZW91
dCkpIHsKKwkJZGV2X2luZm8ocHJpdi0+YWRhcHRlci0+ZGV2LCAicnhfcGVuZGluZyBrZXJuZWw6
JWRcbiIsIGF0b21pY19yZWFkKCZwcml2LT5hZGFwdGVyLT5yeF9wZW5kaW5nKSk7CisJCXRpbWVv
dXQgPSBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg1MDApOworCX0KKwogCWlmIChpbl9pbnRl
cnJ1cHQoKSkKIAkJbmV0aWZfcngoc2tiKTsKIAllbHNlCg==
--001a11c1b66a933aea05067ae306--
