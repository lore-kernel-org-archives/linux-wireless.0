Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44270 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaAGQa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 11:30:28 -0500
Received: by mail-ig0-f179.google.com with SMTP id hk11so2066411igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 08:30:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140107102746.GA20561@magnum.frso.rivierawaves.com>
References: <529CF2D6.1080008@gmail.com> <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
 <20140106150716.GA5358@magnum.frso.rivierawaves.com> <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com>
 <20140107102746.GA20561@magnum.frso.rivierawaves.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 7 Jan 2014 18:30:07 +0200
Message-ID: <CAF8O4-xaNWO+tFS=0+ffR5aKf0Z+OWDBSPpnjYWUgP86Oiey2g@mail.gmail.com> (sfid-20140107_173031_692973_2704A99F)
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state machine
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: multipart/mixed; boundary=047d7bdc9db2ddb43104ef63e4da
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--047d7bdc9db2ddb43104ef63e4da
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 7, 2014 at 12:27 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> On Mon, Jan 06, 2014 at 08:04:03PM +0200, Eyal Shapira wrote:
>> On Mon, Jan 6, 2014 at 5:07 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
>> > On Mon, Dec 02, 2013 at 10:59:24PM +0200, Emmanuel Grumbach wrote:
>> >> From: Eyal Shapira <eyal@wizery.com>
>> >>
>> >> Rewrite the search cycle state machine to use a more data
>> >> oriented approach where the different Tx columns (configs)
>> >> limitations and next columns to search are reprsented in
>> >> tables which are easy to change. This overhaul also includes
>> >> several major fixes:
>> >>
>> >> 1. Prevent going back to a specific Tx column in a search
>> >> cycle if it was already explored.
>> >>
>> >> 2. Avoid switching to a Tx column that doesn't have any chance
>> >> if it performs perfectly to beat the current throughput we're
>> >> getting.
>> >>
>> >> These issues were degrading throughput as they were causing
>> >> switching to "bad" Tx columns.
>> >>
>> >> Signed-off-by: Eyal Shapira <eyal@wizery.com>
>> >> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> >> ---
>> >>  drivers/net/wireless/iwlwifi/mvm/rs.c |  921 +++++++++++++++------------------
>> >>  drivers/net/wireless/iwlwifi/mvm/rs.h |   64 +--
>> >>  2 files changed, 458 insertions(+), 527 deletions(-)
>> >>
>> >> @@ -1772,7 +1712,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
>> > [...]
>> >> -     if (done_search && !lq_sta->stay_in_tbl) {
>> >> +     if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
>> >>               /* If the "active" (non-search) mode was legacy,
>> > [...]
>> >
>> > Hi,
>> >
>> > Trying -testing right now on my laptop and this commit broke aggregation.
>> >
>>
>> Thanks Karl for the report.
>> I'm seeing Tx aggregation. Note that it doesn't start off immediately
>> but only after enough traffic went through for us to explore different
>> Tx configurations.
>>
>> Some questions:
>> 1. How do you see aggregation is broken ? sniffer or just lower
>> throughput you're getting ?
> It doesn't send any addBA action frame and traffic is not aggregated.
>
>> 2. What's the chip ?
> AC 7260, REV=0x144
>
>> 3. Do you connect in 11n or 11ac ?
> Tried both
>
>> 4. Any chance you can set module parameter debug=0x04100000 and send the logs ?
>> Configuring IWLWIFI_DEBUG is required.
> Here you are.
>

Thanks. Seems like we decided the AP doesn't support any MIMO rates.
This wasn't handled well and caused the search cycle for an optimal Tx
configuration to get stuck.
Can you try the attached patch ?

Also, any chance you can send a traffic capture of some beacons and the assoc ?
I'd like to understand why we come to the conclusion no MIMO is supported.

Thanks,
Eyal

--047d7bdc9db2ddb43104ef63e4da
Content-Type: text/x-patch; charset=US-ASCII;
	name="0001-iwlwifi-mvm-rs-fix-handling-of-column-switch-error.patch"
Content-Disposition: attachment;
	filename="0001-iwlwifi-mvm-rs-fix-handling-of-column-switch-error.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hq5dis3e1

RnJvbSA5ZTFmMTI1MDBhNjU4ZWQzODAwNGVlYzBkODlmMGVjOGJlYWY5YTg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFeWFsIFNoYXBpcmEgPGV5YWxAd2l6ZXJ5LmNvbT4KRGF0ZTog
VHVlLCA3IEphbiAyMDE0IDE4OjE5OjM1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gaXdsd2lmaTog
bXZtOiByczogZml4IGhhbmRsaW5nIG9mIGNvbHVtbiBzd2l0Y2ggZXJyb3IKCklmIHdlIGNhbid0
IHN3aXRjaCB0byBhIGNvbHVtbiBiZWNhdXNlIG5vIHJhdGVzIGFyZSBzdXBwb3J0ZWQKaW4gdGhh
dCBjb2x1bW4gdGhpcyBsZWQgdG8gYSBzdGF0ZSB3aGVyZSB0aGUgc2VhcmNoIGN5Y2xlCmdvdCBz
dHVjayBhbmQgbmV2ZXIgZW5kZWQuIFRoaXMgaW4gdHVybiBhbHNvIGxlZCB0byBhZ2dyZWdhdGlv
bgpub3QgYmVpbmcgdHVybmVkIG9uLiBGaXggdGhpcyBieSBtYXJraW5nIGEgY29sdW1uIGFzCnZp
c2l0ZWQgaWYgd2UgY2FuJ3Qgc3dpdGNoIHRvIGl0LgoKQ2hhbmdlLUlkOiBJOThmZDAzMDNkMDQz
YTUzZWM1NTdkMWY3MDQ0ZmYzOTkxZWU3YjQ4MQpSZXBvcnRlZC1ieTogS2FybCBCZWxkYW4gPGth
cmwuYmVsZGFuQGdtYWlsLmNvbT4KU2lnbmVkLW9mZi1ieTogRXlhbCBTaGFwaXJhIDxleWFseC5z
aGFwaXJhQGludGVsLmNvbT4KLS0tCiBkcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9y
cy5jIHwgICAgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRp
b24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9ycy5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9tdm0vcnMuYwppbmRleCA5ZTE1ODZiLi41
YzM2MjczIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL212bS9ycy5j
CisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvbXZtL3JzLmMKQEAgLTE1ODgsNiAr
MTU4OCw4IEBAIHN0YXRpYyBpbnQgcnNfc3dpdGNoX3RvX2NvbHVtbihzdHJ1Y3QgaXdsX212bSAq
bXZtLAogCXNlYXJjaF90YmwtPmNvbHVtbiA9IGNvbF9pZDsKIAlyc19zZXRfZXhwZWN0ZWRfdHB0
X3RhYmxlKGxxX3N0YSwgc2VhcmNoX3RibCk7CiAKKwlscV9zdGEtPnZpc2l0ZWRfY29sdW1ucyB8
PSBCSVQoY29sX2lkKTsKKwogCS8qIEdldCB0aGUgYmVzdCBtYXRjaGluZyByYXRlIGlmIHdlJ3Jl
IGNoYW5naW5nIG1vZGVzLiBlLmcuCiAJICogU0lTTy0+TUlNTywgTEVHQUNZLT5TSVNPLCBNSU1P
LT5TSVNPCiAJICovCkBAIC0xNjExLDcgKzE2MTMsNiBAQCBzdGF0aWMgaW50IHJzX3N3aXRjaF90
b19jb2x1bW4oc3RydWN0IGl3bF9tdm0gKm12bSwKIAlJV0xfREVCVUdfUkFURShtdm0sICJTd2l0
Y2hlZCB0byBjb2x1bW4gJWQ6IEluZGV4ICVkXG4iLAogCQkgICAgICAgY29sX2lkLCByYXRlLT5p
bmRleCk7CiAKLQlscV9zdGEtPnZpc2l0ZWRfY29sdW1ucyB8PSBCSVQoY29sX2lkKTsKIAlyZXR1
cm4gMDsKIAogZXJyOgotLSAKMS43LjEwLjQKCg==
--047d7bdc9db2ddb43104ef63e4da--
