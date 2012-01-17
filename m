Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:35958 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755085Ab2AQQHd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 11:07:33 -0500
Received: by obcva7 with SMTP id va7so6004351obc.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 08:07:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111221113329.GA2235@redhat.com>
References: <CAJZjf_xDm_RaFqxF-r+MAPyh_HcCb+yV4dNrfhr+LH0-z2zk8g@mail.gmail.com>
 <CAJZjf_yEBb3BEf+-Fei78xBmJT1Y_Jr5fPUJNKwi6kvuVg24KA@mail.gmail.com>
 <20111124125414.GA8077@redhat.com> <CAJZjf_zM2zBsoh66KcRwgi-jS7DF-qH5-sKrUoCB=hFTPES7LA@mail.gmail.com>
 <20111221113329.GA2235@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 17 Jan 2012 16:07:12 +0000
Message-ID: <CAJZjf_xJYogUH7i+qp+cy5mxpX3dGTm0O--Ecv8=UMjg+J0vow@mail.gmail.com> (sfid-20120117_170737_234314_FBA11501)
Subject: Re: iwl3945 firmware errors: tentative debugging
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary=f46d0444ee55611a5504b6bb871d
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--f46d0444ee55611a5504b6bb871d
Content-Type: text/plain; charset=ISO-8859-1

Hi!
Sorry for the delay!

On Wed, Dec 21, 2011 at 11:33 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Hi Pedro,
>
> On Tue, Nov 29, 2011 at 05:07:55PM +0000, Pedro Francisco wrote:
>> My country has the following regulatory.bin lines:
>>
>> country PT:
>> (2402.000 - 2482.000 @ 40.000), (N/A, 20.00)
>> (5170.000 - >> 5250.000 @ 40.000), (N/A, 20.00)
>> (5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS <------ removed whole line
>> (5490.000 - 5710.000 @ 40.000), (N/A, 27.00), DFS <------ removed whole line
>>
>> If I remove the last two lines, everything works as expected, i.e., NO
>> "Microsode SW error". If I include any of the last two, the Microcode
>> will issue an error.
>>
>> I've tried every combination of those lines except just one of
>> "(5250.000 - 5330.000 @ 40.000), (N/A, 20.00), DFS" OR "(5490.000 -
>> 5710.000 @ 40.000), (N/A, 27.00), DFS".
>
> Attached patch stop to trigger error on my setup with "iw dev wlan0 scan
> passive". Can you check if it also fix problem on your normal wireless
> workload?

It does seem fixed! However: I had to tweak a little the patch
(attached, for convenience of anyone else following the thread: "IL_"
-> "IWL_", file to patch is different and paragraphs are different).

Also, probably unrelated, I got _just once_ another firmware error
("iwl3945 Command REPLY_RATE_SCALE failed: FW Error
iwl3945 Error setting HW rate table: FFFFFFFB") but since the kernels
have changed and I've also changed to the PAE kernel, it's probably
unrelated to the patch (also I'm using swcrypto=0 which may help).
I'll continue testing but unless there is some other issue I won't
report back.

Thank you for the fix!
-- 
Pedro

--f46d0444ee55611a5504b6bb871d
Content-Type: text/x-patch; charset=US-ASCII;
	name="iwlegacy-CUSTOM-PEDRO-do-not-promote-to-active-scan-on-transmistion-detect.patch"
Content-Disposition: attachment;
	filename="iwlegacy-CUSTOM-PEDRO-do-not-promote-to-active-scan-on-transmistion-detect.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gxj43lm31

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bGVnYWN5L2l3bDM5NDUtYmFzZS5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kvaXdsMzk0NS1iYXNlLmMKaW5kZXggNjZl
ZTE1Ni4uOTZmNWQzMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kv
aXdsMzk0NS1iYXNlLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsZWdhY3kvaXdsMzk0
NS1iYXNlLmMKQEAgLTI2NTksMTIgKzI2NTksMTIgQEAgaW50IGl3bDM5NDVfcmVxdWVzdF9zY2Fu
KHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAl9CiAK
IAkvKgotCSAqIElmIGFjdGl2ZSBzY2FuaW5nIGlzIHJlcXVlc3RlZCBidXQgYSBjZXJ0YWluIGNo
YW5uZWwKLQkgKiBpcyBtYXJrZWQgcGFzc2l2ZSwgd2UgY2FuIGRvIGFjdGl2ZSBzY2FubmluZyBp
ZiB3ZQotCSAqIGRldGVjdCB0cmFuc21pc3Npb25zLgorCSAqIElmIGFjdGl2ZSBzY2FuaW5nIGlz
IHJlcXVlc3RlZCBidXQgYSBjZXJ0YWluIGNoYW5uZWwgaXMgbWFya2VkCisJICogcGFzc2l2ZSwg
d2UgY2FuIGRvIGFjdGl2ZSBzY2FubmluZyBpZiB3ZSBkZXRlY3QgdHJhbnNtaXNzaW9ucy4gRm9y
CisJICogcGFzc2l2ZSBvbmx5IHNjYW5uaW5nIGRpc2FibGUgc3dpdGNoaW5nIHRvIGFjdGl2ZSBv
biBhbnkgY2hhbm5lbC4KIAkgKi8KIAlzY2FuLT5nb29kX0NSQ190aCA9IGlzX2FjdGl2ZSA/IElX
TF9HT09EX0NSQ19USF9ERUZBVUxUIDoKLQkJCQkJSVdMX0dPT0RfQ1JDX1RIX0RJU0FCTEVEOwor
CQkJCQlJV0xfR09PRF9DUkNfVEhfTkVWRVI7CiAKIAlsZW4gPSBpd2xfbGVnYWN5X2ZpbGxfcHJv
YmVfcmVxKHByaXYsIChzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKilzY2FuLT5kYXRhLAogCQkJCQl2
aWYtPmFkZHIsIHByaXYtPnNjYW5fcmVxdWVzdC0+aWUsCg==
--f46d0444ee55611a5504b6bb871d--
