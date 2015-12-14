Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36597 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbbLNMmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 07:42:52 -0500
Received: by lfed137 with SMTP id d137so68325422lfe.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 04:42:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0d9iGRaA9Re-o12ecpz9i5p5Z5ir4h=o3VoEy=oL+7xg@mail.gmail.com>
References: <20151203220522.GB11138@jessup.stsp.name>
	<CANUX_P2qxe+BqLPPWOs5uWiBY5nO4e8C1A7gkkYnvrTG270YFQ@mail.gmail.com>
	<CANUX_P0P5A6q1yQwrgagO5rVpE=6Zk0Fq2gNA-WVhkc7Ov2NdQ@mail.gmail.com>
	<CANUX_P19Aq_PKyUscg8jBkH=XJim1aut9kTmNUrVMeRt-upNyw@mail.gmail.com>
	<20151211200205.GV25635@ted.stsp.name>
	<CANUX_P0d9iGRaA9Re-o12ecpz9i5p5Z5ir4h=o3VoEy=oL+7xg@mail.gmail.com>
Date: Mon, 14 Dec 2015 14:42:50 +0200
Message-ID: <CANUX_P1zs7sPR5kGabX1kk2VPWQM=HRp0t3SeLz7U-EFdcZBkw@mail.gmail.com> (sfid-20151214_134300_262448_4F2A3D3E)
Subject: Re: iwlwifi A-MSDU tx
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stefan Sperling <stsp@openbsd.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001a11403744d7a6280526db0281
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--001a11403744d7a6280526db0281
Content-Type: text/plain; charset=UTF-8

On Sat, Dec 12, 2015 at 10:54 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> On Fri, Dec 11, 2015 at 10:02 PM, Stefan Sperling <stsp@openbsd.org> wrote:
>> Hi Emmanuel,
>>
>> Thanks a bunch, this worked out quite well for me.
>> I got what I was aiming for out of this already but I still have some
>> additional questions if you don't mind.
>
> Happy to hear that.
>
>>
>> Do you know of a good way to generate A-MSDUs?
>> One way I found is to run:
>>   top -d .01
>> on the AP and watching this top over SSH from my associated OpenBSD client.
>
> iperf? :)
>
> You can also load iwlwifi with 11n_disable=2. This will prevent A-MPDU
> if you don't want to have A-MSDU in A-MPDU at that stage.
>
>>
>> It seems only locally generated packets will trigger A-MSDUs.
>> I suppose forwarded frames always fit the interface MTU and don't
>> trigger A-MSDUs. Is there a way to test this with forwarded traffic?
>
> Hmm. Good question. A-MSDUs are created each time we get a large send
> from the network stack. I think that this relies on the socket
> occupancy which means that you are right. I don't think we can test
> this with forwarded traffic for now.
>
>>
>> One issue I discovered is that OpenBSD (with my partly uncommitted 11n
>> patch set) cannot decrypt encrypted A-MSDUs sent by iwlwifi.
>> Frames carrying normal MSDUs have a CCMP header and are decrypted correctly.
>> But frames carrying A-MSDUs have a wep/tkip header (wireshark shows
>> "WEP parameters" instead of CCMP parameters") and decryption fails on
>> OpenBSD in ieee80211_ccmp_decrypt() because the ExtIV bit is not set.
>> It doesn't look like the source of this problem is at OpenBSD's end since
>> CCMP is required for HT. So in case the firmware doesn't produce CCMP for
>> A-MSDUs, this would be a problem in the firmware. Can you confirm this?
>> I also tried running iwlwifi in software crypto mode but the AP would
>> not send A-MSDUs at all in that case.
>
> SW crypto won't work for A-MSDU since it'll refuse LSO which in turn
> disables A-MSDU.
> I don't really touch the wifi header, I just duplicate it if needed,
> so I don't see off the top of my head where the problem could be.
> Thanks for reporting it.
>

I found the problem. Patch attached.

>>
>> On the receiving OpenBSD side I'm currently limited to 4k A-MSDU and it
>> turns out the AP won't send more than 2 subframes per A-MSDU in this case.
>
> with default MTU, you won't get more than that.
>
>> To test with more than 2 subframes I applied the following crude patch which
>> makes the AP send more subframes but crashes the firmware after the frame
>> is sent. The driver recovers fine and traffic keeps flowing but that's
>> not pretty. Do you have a better idea? If not, no problem. I mainly did
>> this to confirm that OpenBSD won't crash handling A-MSDU with more than
>> 2 subframes, which it won't.
>
> ouch. No :)  What you should really do is to reduce the MTU to 500 bytes.
> iperf -M will do.
>
>>
>> Thanks again,
>> Stefan
>>
>> diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
>> index 7ece5c1..b3d562d 100644
>> --- a/drivers/net/wireless/iwlwifi/mvm/tx.c
>> +++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
>> @@ -448,7 +448,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
>>         struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
>>         struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>>         struct ieee80211_hdr *hdr = (void *)skb->data;
>> -       unsigned int mss = skb_shinfo(skb)->gso_size;
>> +       unsigned int mss = skb_shinfo(skb)->gso_size / 2;
>>         struct sk_buff *tmp, *next;
>>         char cb[sizeof(skb->cb)];
>>         unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
>>
>> On Fri, Dec 04, 2015 at 12:30:52PM +0200, Emmanuel Grumbach wrote:
>>> Adding the right mailing list this time.
>>>
>>> On Fri, Dec 4, 2015 at 10:18 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> > On Fri, Dec 4, 2015 at 9:35 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>> >> Hi,
>>> >>
>>> >> On Fri, Dec 4, 2015 at 12:05 AM, Stefan Sperling <stsp@openbsd.org> wrote:
>>> >>> Hi Emmanuel,
>>> >>>
>>> >>> As part of implementing 802.11n support in OpenBSD I'm looking for
>>> >>> an AP which sends A-MSDUs. Preferrably under software control rather
>>> >>> than firmware.
>>> >>>
>>> >>> I found your iwlwifi A-MSDU patches at
>>> >>> http://marc.info/?l=linux-wireless&m=144553311122495&w=2
>>> >>> and http://marc.info/?l=linux-wireless&m=144553311822496&w=2
>>> >>>
>>> >>> Would these patches make it possible to run an AP with an 5300 or 7260
>>> >>> card and send A-MSDUs? That would be great as I have the necessary hardware.
>>> >>
>>> >> 7260 will go. Not 5300.
>>> >> Note that this code simulates Tx TCP Csum offload. I did that to write
>>> >> the code while we still don't have the hardware that has this
>>> >> capability. But for testing purposes, it should do the work. The
>>> >> testing teams have reported that AP mode didn't work quite well with
>>> >> this and I haven't taken the time to look into yet, but if you see
>>> >> issues, please report them or even better: fix them :)
>>> >>
>>> >>>
>>> >>> Which Linux tree do these patches apply to? I've tried the following
>>> >>> but had no luck in getting these patches applied without rejects:
>>> >>>
>>> >>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>> >>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
>>> >>>
>>> >>
>>> >> Right. These patches had a long internal review cycle. They are now
>>> >> merge in our internal tree.
>>> >> You can find them in our internal tree [1] (backport based). I will
>>> >> push them soon in iwlwifi-next.git.
>>> >
>>> > I forgot to mention that you need to change the define of
>>> > IWL_MVM_SW_TX_CSUM_OFFLOAD to 1.
>>> >
>>> >>
>>> >> [1] - https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/
>>> >> Please read https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release#how_to_install_the_driver.
>>> >>
>>> >>> Thanks,
>>> >>> Stefan

--001a11403744d7a6280526db0281
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-BUGFIX-iwlwifi-pcie-correctly-handle-the-IV-in-A-MSD.patch"
Content-Disposition: attachment;
	filename="0001-BUGFIX-iwlwifi-pcie-correctly-handle-the-IV-in-A-MSD.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ii5yalql0

RnJvbSA5ZWYwZGI0YTY5Mjk3YmNjMDAxYzhkMjU4ODgwMWJjNDg5ODM0YjU5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBNb24sIDE0IERlYyAyMDE1IDE0OjMxOjU5ICswMjAwClN1YmplY3Q6
IFtQQVRDSF0gW0JVR0ZJWF0gaXdsd2lmaTogcGNpZTogY29ycmVjdGx5IGhhbmRsZSB0aGUgSVYg
aW4gQS1NU0RVCiBbU1FVQVNIXQoKVGhlIElWIG5lZWRzIHRvIGJlIGNvcGllZCBiZWZvcmUgaXQg
aXMgcHVsbGVkIGZyb20gdGhlIHNrYi4KVGhpcyBwcmV2ZW50ZWQgVFNPIHRvIHdvcmsgcHJvcGVy
bHkgd2l0aCBpdl9sZW4gIT0gMC4KCnR5cGU9YnVnZml4CmJ1Zz1ub3QtdHJhY2tlZApmaXhlcz1J
OWQwMmJlNWI4MzQ5MTIwZTczZDg5OTdkOTExODJhZWMyZjQyMjkwZgoKQ2hhbmdlLUlkOiBJZWFi
ODhmZGMxOGNkOTAwNjZmZjU3MWVhMmJkMTFiYTc5ZWE2ZjA0MApTaWduZWQtb2ZmLWJ5OiBFbW1h
bnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMv
bmV0L3dpcmVsZXNzL2l3bHdpZmkvcGNpZS90eC5jIHwgMTUgKysrKysrKystLS0tLS0tCiAxIGZp
bGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvcGNpZS90eC5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaXdsd2lmaS9wY2llL3R4LmMKaW5kZXggZmQzNmVlYS4uMTRkNWZmZCAxMDA2NDQKLS0t
IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9wY2llL3R4LmMKKysrIGIvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvaXdsd2lmaS9wY2llL3R4LmMKQEAgLTE5NzcsMTUgKzE5NzcsMTAgQEAgc3Rh
dGljIGludCBpd2xfZmlsbF9kYXRhX3Ric19hbXNkdShzdHJ1Y3QgaXdsX3RyYW5zICp0cmFucywg
c3RydWN0IHNrX2J1ZmYgKnNrYiwKIAkJCSAgICAgJmRldl9jbWQtPmhkciwgSVdMX0hDTURfU0NS
QVRDSEJVRl9TSVpFICsgdGIxX2xlbiwKIAkJCSAgICAgTlVMTCwgMCk7CiAKLQkvKgotCSAqIFB1
bGwgdGhlIGllZWU4MDIxMSBoZWFkZXIgKyBJViB0byBiZSBhYmxlIHRvIHVzZSBUU08gY29yZSwK
LQkgKiB3ZSB3aWxsIHJlc3RvcmUgaXQgZm9yIHRoZSB0eF9zdGF0dXMgZmxvdy4KLQkgKi8KLQlz
a2JfcHVsbChza2IsIGhkcl9sZW4gKyBpdl9sZW4pOwogCWlwX2hkcmxlbiA9IHNrYl90cmFuc3Bv
cnRfaGVhZGVyKHNrYikgLSBza2JfbmV0d29ya19oZWFkZXIoc2tiKTsKIAlzbmFwX2lwX3RjcF9o
ZHJsZW4gPQogCQlJRUVFODAyMTFfQ0NNUF9IRFJfTEVOICsgaXBfaGRybGVuICsgdGNwX2hkcmxl
bihza2IpOwotCXRvdGFsX2xlbiA9IHNrYi0+bGVuIC0gc25hcF9pcF90Y3BfaGRybGVuOworCXRv
dGFsX2xlbiA9IHNrYi0+bGVuIC0gc25hcF9pcF90Y3BfaGRybGVuIC0gaGRyX2xlbiAtIGl2X2xl
bjsKIAlhbXNkdV9wYWQgPSAwOwogCiAJLyogdG90YWwgYW1vdW50IG9mIGhlYWRlciB3ZSBtYXkg
bmVlZCBmb3IgdGhpcyBBLU1TRFUgKi8KQEAgLTIwMDAsOSArMTk5NSwxNSBAQCBzdGF0aWMgaW50
IGl3bF9maWxsX2RhdGFfdGJzX2Ftc2R1KHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBzdHJ1Y3Qg
c2tfYnVmZiAqc2tiLAogCWdldF9wYWdlKGhkcl9wYWdlLT5wYWdlKTsKIAlzdGFydF9oZHIgPSBo
ZHJfcGFnZS0+cG9zOwogCWluZm8tPmRyaXZlcl9kYXRhW0lXTF9UUkFOU19GSVJTVF9EUklWRVJf
REFUQV0gPSBoZHJfcGFnZS0+cGFnZTsKLQltZW1jcHkoaGRyX3BhZ2UtPnBvcywgc2tiLT5kYXRh
LCBpdl9sZW4pOworCW1lbWNweShoZHJfcGFnZS0+cG9zLCBza2ItPmRhdGEgKyBoZHJfbGVuLCBp
dl9sZW4pOwogCWhkcl9wYWdlLT5wb3MgKz0gaXZfbGVuOwogCisJLyoKKwkgKiBQdWxsIHRoZSBp
ZWVlODAyMTEgaGVhZGVyICsgSVYgdG8gYmUgYWJsZSB0byB1c2UgVFNPIGNvcmUsCisJICogd2Ug
d2lsbCByZXN0b3JlIGl0IGZvciB0aGUgdHhfc3RhdHVzIGZsb3cuCisJICovCisJc2tiX3B1bGwo
c2tiLCBoZHJfbGVuICsgaXZfbGVuKTsKKwogCXRzb19zdGFydChza2IsICZ0c28pOwogCiAJd2hp
bGUgKHRvdGFsX2xlbikgewotLSAKMi41LjAKCg==
--001a11403744d7a6280526db0281--
