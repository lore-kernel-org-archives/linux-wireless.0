Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48934 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3IJCwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 22:52:33 -0400
Received: by mail-oa0-f52.google.com with SMTP id f4so7362159oah.11
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 19:52:33 -0700 (PDT)
Message-ID: <522E896E.7000607@lwfinger.net> (sfid-20130910_045237_680368_0183612B)
Date: Mon, 09 Sep 2013 21:52:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk>
In-Reply-To: <522E5D83.9060103@ilande.co.uk>
Content-Type: multipart/mixed;
 boundary="------------090009050802040909060902"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090009050802040909060902
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/09/2013 06:45 PM, Mark Cave-Ayland wrote:
> dmesg output:
> http://www.ilande.co.uk/tmp/rtl8192cu_patch-3-dmesg.txt
>
> wpa_supplicant output:
> http://www.ilande.co.uk/tmp/rtl8192cu_patch-3-wpa_supplicant.txt
>
> Now the interesting part was as you can see from the logs, I managed to get a
> reasonably long association to the AP towards the end so I tried running
> dhclient against the wlan1 interface - this was slow, taking about 60s to
> complete, but it did eventually return with an IP address. With that in place, I
> tried pinging 8.8.8.8 and ended up with a very poor connection, with the ping
> exit banner reporting 87% packet loss :(

We now know that the beacons are being lost. The last one was at 90600.642566 as 
shown below:

Sep 10 00:29:48 kentang kernel: [90599.513526] rtlwifi: mode 2, state 2, 
is_beacon 1, is_probe_resp 0, length 153
Sep 10 00:29:50 kentang kernel: [90600.642566] rtlwifi: mode 2, state 2, 
is_beacon 1, is_probe_resp 0, length 153
Sep 10 00:29:57 kentang kernel: [90607.829051] 
rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
Sep 10 00:29:57 kentang kernel: [90607.829058] wlan1: Connection to AP 
00:1f:9f:d5:a8:3b lost
Sep 10 00:29:57 kentang kernel: [90607.830086] cfg80211: Calling CRDA to update 
world regulatory domain

We have to conclude that your interface has been shut down as we have gotten no 
beacons or RX data packets received. Unfortunately, my restricting the output to 
only your AP does not let me know if any data are being received. I hate to do 
this, but the attached patch will dump all packets again with no limit. Once you 
get a disconnect, then you can stop the run before the log gets too full.

Larry



--------------090009050802040909060902
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_dump_AP_off"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_dump_AP_off"

SW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3VzYi5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmln
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvdXNiLmMKKysrIHdpcmVsZXNzLXRlc3Rp
bmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3VzYi5jCkBAIC00ODQsNiAr
NDg0LDggQEAgc3RhdGljIHZvaWQgX3J0bF91c2JfcnhfcHJvY2Vzc19hZ2coc3RydQogCQkJ
aWYgKHVuaWNhc3QpCiAJCQkJcnRscHJpdi0+bGlua19pbmZvLm51bV9yeF9pbnBlcmlvZCsr
OwogCQl9CisJCS8qIHN0YXRpYyBiY24gZm9yIHJvYW1pbmcgKi8KKwkJcnRsX2JlYWNvbl9z
dGF0aXN0aWMoaHcsIHNrYik7CiAJfQogfQogCkluZGV4OiB3aXJlbGVzcy10ZXN0aW5nLXNh
dmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9jb3JlLmMKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQot
LS0gd2lyZWxlc3MtdGVzdGluZy1zYXZlLm9yaWcvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRs
d2lmaS9jb3JlLmMKKysrIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGx3aWZpL2NvcmUuYwpAQCAtMTg0LDYgKzE4NCw3IEBAIHN0YXRpYyBpbnQgcnRs
X29wX2FkZF9pbnRlcmZhY2Uoc3RydWN0IGkKIAkJCQkJcnRscHJpdi0+Y2ZnLT5tYXBzCiAJ
CQkJCVtSVExfSUJTU19JTlRfTUFTS1NdKTsKIAkJfQorCQltYWMtPmxpbmtfc3RhdGUgPSBN
QUM4MDIxMV9MSU5LRUQ7CiAJCWJyZWFrOwogCWNhc2UgTkw4MDIxMV9JRlRZUEVfQURIT0M6
CiAJCVJUX1RSQUNFKHJ0bHByaXYsIENPTVBfTUFDODAyMTEsIERCR19MT1VELApJbmRleDog
d2lyZWxlc3MtdGVzdGluZy1zYXZlL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFz
ZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS5vcmlnL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvYmFzZS5jCisrKyB3aXJlbGVzcy10ZXN0aW5nLXNh
dmUvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsd2lmaS9iYXNlLmMKQEAgLTEyODgsNiArMTI4
OCwxMCBAQCB2b2lkIHJ0bF9iZWFjb25fc3RhdGlzdGljKHN0cnVjdCBpZWVlODAyCiAJc3Ry
dWN0IHJ0bF9wcml2ICpydGxwcml2ID0gcnRsX3ByaXYoaHcpOwogCXN0cnVjdCBpZWVlODAy
MTFfaGRyICpoZHIgPSAoc3RydWN0IGllZWU4MDIxMV9oZHIgKilza2ItPmRhdGE7CiAKKwlw
cl9pbmZvKCJtb2RlICVkLCBzdGF0ZSAlZCwgaXNfYmVhY29uICVkLCBpc19wcm9iZV9yZXNw
ICVkLCBsZW5ndGggJWRcbiIsCisJCXJ0bHByaXYtPm1hYzgwMjExLm9wbW9kZSwgcnRscHJp
di0+bWFjODAyMTEubGlua19zdGF0ZSwgaWVlZTgwMjExX2lzX2JlYWNvbihoZHItPmZyYW1l
X2NvbnRyb2wpLAorCQlpZWVlODAyMTFfaXNfcHJvYmVfcmVzcChoZHItPmZyYW1lX2NvbnRy
b2wpLCBza2ItPmxlbik7CisKIAlpZiAocnRscHJpdi0+bWFjODAyMTEub3Btb2RlICE9IE5M
ODAyMTFfSUZUWVBFX1NUQVRJT04pCiAJCXJldHVybjsKIAo=
--------------090009050802040909060902--
