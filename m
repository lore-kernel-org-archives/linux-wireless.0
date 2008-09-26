Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:7389 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYIZL4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 07:56:06 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1059517wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 04:56:06 -0700 (PDT)
Message-ID: <eb3ff54b0809260455o6bd44c69m8c0456acb99ec6a8@mail.gmail.com> (sfid-20080926_135612_319243_04774EB3)
Date: Fri, 26 Sep 2008 14:56:05 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] [RESEND] mac80211: remove wme_tx_queue and wme_rx_queue from net/mac80211/sta_info.h
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1222427168.10563.106.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_10488_22158873.1222430166213"
References: <eb3ff54b0809251045m47949af5u6a1615f0d42d37a2@mail.gmail.com>
	 <1222427168.10563.106.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_10488_22158873.1222430166213
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

This patch removes wme_tx_queue and wme_rx_queue from struct sta_info
and from the debugfs sub-structure of struct sta_info
in net/mac80211/sta_info.h, as they are useless and not used.


Regards,
Rami Rosen

Signed-off-by: Rami Rosen <ramirose@gmail.com>


On Fri, Sep 26, 2008 at 2:06 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-09-25 at 20:45 +0300, Rami Rosen wrote:
>> Hi,
>>   This patch removes wme_tx_queue and wme_rx_queue from net/mac80211/sta_info.h
>>   as they are not used. (These variable names in fact a double declaration; one
>>   is a pointer to dentry struct (for DEBUGFS) and the second is an
>> array of ints
>>  (for Extra statistics for TX/RX debugging - when setting
>>  CONFIG_MAC80211_DEBUG_COUNTERS); both are not used.
>
> Not really a double declaration since one of them is in the debugfs
> sub-structure, but yeah, useless.
>
>>
>>
>> Regards,
>> Rami Rosen
>>
>> Signed-off-by: Rami Rosen <ramirose@gmail.com>
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
> but you may need to resend with a patch description appropriate for the
> changelog, I'll let John sort that out I guess.
>
> johannes
>

------=_Part_10488_22158873.1222430166213
Content-Type: text/plain; name=patch.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_flkr8b3j1
Content-Disposition: attachment; filename=patch.txt

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9zdGFfaW5mby5oIGIvbmV0L21hYzgwMjExL3N0YV9p
bmZvLmgKaW5kZXggMTA5ZGI3OC4uODFjMzM2OCAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3N0
YV9pbmZvLmgKKysrIGIvbmV0L21hYzgwMjExL3N0YV9pbmZvLmgKQEAgLTE5MSw3ICsxOTEsNiBA
QCBzdHJ1Y3Qgc3RhX2FtcGR1X21sbWUgewogICogQGxhc3RfcXVhbDogcXVhbCBvZiBsYXN0IHJl
Y2VpdmVkIGZyYW1lIGZyb20gdGhpcyBTVEEKICAqIEBsYXN0X25vaXNlOiBub2lzZSBvZiBsYXN0
IHJlY2VpdmVkIGZyYW1lIGZyb20gdGhpcyBTVEEKICAqIEBsYXN0X3NlcV9jdHJsOiBsYXN0IHJl
Y2VpdmVkIHNlcS9mcmFnIG51bWJlciBmcm9tIHRoaXMgU1RBIChwZXIgUlggcXVldWUpCi0gKiBA
d21lX3J4X3F1ZXVlOiBUQkQKICAqIEB0eF9maWx0ZXJlZF9jb3VudDogVEJECiAgKiBAdHhfcmV0
cnlfZmFpbGVkOiBUQkQKICAqIEB0eF9yZXRyeV9jb3VudDogVEJECkBAIC0yMDQsNyArMjAzLDYg
QEAgc3RydWN0IHN0YV9hbXBkdV9tbG1lIHsKICAqIEB0eF9mcmFnbWVudHM6IG51bWJlciBvZiB0
cmFuc21pdHRlZCBNUERVcwogICogQHR4cmF0ZV9pZHg6IFRCRAogICogQGxhc3RfdHhyYXRlX2lk
eDogVEJECi0gKiBAd21lX3R4X3F1ZXVlOiBUQkQKICAqIEBhbXBkdV9tbG1lOiBUQkQKICAqIEB0
aW1lcl90b190aWQ6IGlkZW50aXR5IG1hcHBpbmcgdG8gSUQgdGltZXJzCiAgKiBAdGlkX3RvX3R4
X3E6IG1hcCB0aWQgdG8gdHggcXVldWUKQEAgLTI2NSw5ICsyNjMsNiBAQCBzdHJ1Y3Qgc3RhX2lu
Zm8gewogCWludCBsYXN0X3F1YWw7CiAJaW50IGxhc3Rfbm9pc2U7CiAJX19sZTE2IGxhc3Rfc2Vx
X2N0cmxbTlVNX1JYX0RBVEFfUVVFVUVTXTsKLSNpZmRlZiBDT05GSUdfTUFDODAyMTFfREVCVUdf
Q09VTlRFUlMKLQl1bnNpZ25lZCBpbnQgd21lX3J4X3F1ZXVlW05VTV9SWF9EQVRBX1FVRVVFU107
Ci0jZW5kaWYKIAogCS8qIFVwZGF0ZWQgZnJvbSBUWCBzdGF0dXMgcGF0aCBvbmx5LCBubyBsb2Nr
aW5nIHJlcXVpcmVtZW50cyAqLwogCXVuc2lnbmVkIGxvbmcgdHhfZmlsdGVyZWRfY291bnQ7CkBA
IC0yODYsOSArMjgxLDYgQEAgc3RydWN0IHN0YV9pbmZvIHsKIAlpbnQgdHhyYXRlX2lkeDsKIAlp
bnQgbGFzdF90eHJhdGVfaWR4OwogCXUxNiB0aWRfc2VxW0lFRUU4MDIxMV9RT1NfQ1RMX1RJRF9N
QVNLICsgMV07Ci0jaWZkZWYgQ09ORklHX01BQzgwMjExX0RFQlVHX0NPVU5URVJTCi0JdW5zaWdu
ZWQgaW50IHdtZV90eF9xdWV1ZVtOVU1fUlhfREFUQV9RVUVVRVNdOwotI2VuZGlmCiAKIAkvKgog
CSAqIEFnZ3JlZ2F0aW9uIGluZm9ybWF0aW9uLCBsb2NrZWQgd2l0aCBsb2NrLgpAQCAtMzE5LDEw
ICszMTEsNiBAQCBzdHJ1Y3Qgc3RhX2luZm8gewogCQlzdHJ1Y3QgZGVudHJ5ICpudW1fcHNfYnVm
X2ZyYW1lczsKIAkJc3RydWN0IGRlbnRyeSAqaW5hY3RpdmVfbXM7CiAJCXN0cnVjdCBkZW50cnkg
Kmxhc3Rfc2VxX2N0cmw7Ci0jaWZkZWYgQ09ORklHX01BQzgwMjExX0RFQlVHX0NPVU5URVJTCi0J
CXN0cnVjdCBkZW50cnkgKndtZV9yeF9xdWV1ZTsKLQkJc3RydWN0IGRlbnRyeSAqd21lX3R4X3F1
ZXVlOwotI2VuZGlmCiAJCXN0cnVjdCBkZW50cnkgKmFnZ19zdGF0dXM7CiAJfSBkZWJ1Z2ZzOwog
I2VuZGlmCg==
------=_Part_10488_22158873.1222430166213--
