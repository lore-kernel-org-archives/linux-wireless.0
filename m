Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59766 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab1LVQG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 11:06:57 -0500
Received: by ggdk6 with SMTP id k6so6321203ggd.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Dec 2011 08:06:56 -0800 (PST)
Message-ID: <4EF3559C.9060500@lwfinger.net> (sfid-20111222_170700_887440_DA3602F6)
Date: Thu, 22 Dec 2011 10:06:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Darshan Kumar NANDANWAR <Darshan.KN@st.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Srikrishna Pramoda ATIKUKKE <srikrishna.pramodaatikukke@st.com>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com> <4EF1F32F.8070704@lwfinger.net> <20111221151605.GA11842@tuxdriver.com> <4EF235B9.3020805@lwfinger.net> <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BE7A@EAPEX1MAIL1.st.com>
In-Reply-To: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BE7A@EAPEX1MAIL1.st.com>
Content-Type: multipart/mixed;
 boundary="------------060100060204010406060901"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060100060204010406060901
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/2011 04:09 AM, Darshan Kumar NANDANWAR wrote:
> OOPs is in  following instruction :
> pcipriv->ndis_adapter.pcibridge_vendorid = bridge_pdev->vendor;
> 656:       15 0a           mov.w   r1,@(r0,r10)
> I have attached the objdump aswell ..
>
>>> The fix came with commit b6b67df3f24c45af0012ee, which is dated Jul 29.
> What is this all about? Could you point to  this commit?

Kernel source is now maintained using git, which keeps track of changes using 
the sha1sum of the changes. The ID above is the leading digits of that sum.

The patch in question is attached. It handles the cases where the self member of 
the pci_bus struct is not present. It appears not to have been applied to your 
source. Does this patch fix your problem?

Larry



--------------060100060204010406060901
Content-Type: text/plain;
 name="patch_b6b67df"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch_b6b67df"

Y29tbWl0IGI2YjY3ZGYzZjI0YzQ1YWYwMDEyZWUzYzhhZjJmNjJjYTA4M2FlMTgKQXV0aG9y
OiBMYXJyeSBGaW5nZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+CkRhdGU6ICAgRnJp
IEp1bCAyOSAxMDo1MzoxMiAyMDExIC0wNTAwCgogICAgcnRsd2lmaTogRml4IGtlcm5lbCBv
b3BzIG9uIEFSTSBTT0MKICAgIAogICAgVGhpcyBkcml2ZXIgdXNlcyBpbmZvcm1hdGlvbiBm
cm9tIHRoZSBzZWxmIG1lbWJlciBvZiB0aGUgcGNpX2J1cyBzdHJ1Y3QgdG8KICAgIGdldCBp
bmZvcm1hdGlvbiByZWdhcmRpbmcgdGhlIGJyaWRnZSB0byB3aGljaCB0aGUgUENJZSBkZXZp
Y2UgaXMgYXR0YWNoZWQuCiAgICBVbmZvcnR1bmF0ZWx5LCB0aGlzIG1lbWJlciBpcyBub3Qg
ZXN0YWJsaXNoZWQgb24gYWxsIGFyY2hpdGVjdHVyZXMsIHdoaWNoCiAgICBsZWFkcyB0byBh
IGtlcm5lbCBvb3BzLgogICAgCiAgICBTa2lwcGluZyB0aGUgZW50aXJlIGJsb2NrIHRoYXQg
dXNlcyB0aGUgc2VsZiBtZW1iZXIgdG8gZGV0ZXJtaW5lIHRoZSBicmlkZ2UKICAgIHZlbmRv
ciB3aWxsIG9ubHkgYWZmZWN0IFJUTDgxOTJERSBkZXZpY2VzIGFzIHRoYXQgZHJpdmVyIHNl
dHMgdGhlIEFTUE0gc3VwcG9ydAogICAgZmxhZyBkaWZmZXJlbnRseSB3aGVuIHRoZSBicmlk
Z2UgdmVuZG9yIGlzIEludGVsLiBJZiB0aGUgc2VsZiBtZW1iZXIgaXMKICAgIGF2YWlsYWJs
ZSwgdGhlcmUgaXMgbm8gZnVuY3Rpb25hbCBjaGFuZ2UuCiAgICAKICAgIFRoaXMgcGF0Y2gg
Zml4ZXMgQnVnemlsbGEgTm8uIDQwMjEyLgogICAgCiAgICBSZXBvcnRlZC1ieTogSHViZXJ0
IExpYW8gPGxpYW8uaHViZXJ0dEBnbWFpbC5jb20+CiAgICBTaWduZWQtb2ZmLWJ5OiBMYXJy
eSBGaW5nZXIgPExhcnJ5LkZpbmdlckBsd2Zpbmdlci5uZXQ+CiAgICBDYzogU3RhYmxlIDxz
dGFibGVAa2VybmVsLm9yZz4gW2JhY2sgdG8gMi42LjM4XQogICAgU2lnbmVkLW9mZi1ieTog
Sm9obiBXLiBMaW52aWxsZSA8bGludmlsbGVAdHV4ZHJpdmVyLmNvbT4KCmRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcnRsd2lmaS9wY2kuYwppbmRleCA1ZWZkNTc4Li41NmYxMjM1IDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZpL3BjaS5jCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL3J0bHdpZmkvcGNpLmMKQEAgLTE2OTYsMTUgKzE2OTYsMTcgQEAgc3RhdGlj
IGJvb2wgX3J0bF9wY2lfZmluZF9hZGFwdGVyKHN0cnVjdCBwY2lfZGV2ICpwZGV2LAogCXBj
aXByaXYtPm5kaXNfYWRhcHRlci5kZXZudW1iZXIgPSBQQ0lfU0xPVChwZGV2LT5kZXZmbik7
CiAJcGNpcHJpdi0+bmRpc19hZGFwdGVyLmZ1bmNudW1iZXIgPSBQQ0lfRlVOQyhwZGV2LT5k
ZXZmbik7CiAKLQkvKmZpbmQgYnJpZGdlIGluZm8gKi8KLQlwY2lwcml2LT5uZGlzX2FkYXB0
ZXIucGNpYnJpZGdlX3ZlbmRvcmlkID0gYnJpZGdlX3BkZXYtPnZlbmRvcjsKLQlmb3IgKHRt
cCA9IDA7IHRtcCA8IFBDSV9CUklER0VfVkVORE9SX01BWDsgdG1wKyspIHsKLQkJaWYgKGJy
aWRnZV9wZGV2LT52ZW5kb3IgPT0gcGNpYnJpZGdlX3ZlbmRvcnNbdG1wXSkgewotCQkJcGNp
cHJpdi0+bmRpc19hZGFwdGVyLnBjaWJyaWRnZV92ZW5kb3IgPSB0bXA7Ci0JCQlSVF9UUkFD
RShydGxwcml2LCBDT01QX0lOSVQsIERCR19ETUVTRywKLQkJCQkgKCJQY2kgQnJpZGdlIFZl
bmRvciBpcyBmb3VuZCBpbmRleDogJWRcbiIsCi0JCQkJICB0bXApKTsKLQkJCWJyZWFrOwor
CWlmIChicmlkZ2VfcGRldikgeworCQkvKmZpbmQgYnJpZGdlIGluZm8gaWYgYXZhaWxhYmxl
ICovCisJCXBjaXByaXYtPm5kaXNfYWRhcHRlci5wY2licmlkZ2VfdmVuZG9yaWQgPSBicmlk
Z2VfcGRldi0+dmVuZG9yOworCQlmb3IgKHRtcCA9IDA7IHRtcCA8IFBDSV9CUklER0VfVkVO
RE9SX01BWDsgdG1wKyspIHsKKwkJCWlmIChicmlkZ2VfcGRldi0+dmVuZG9yID09IHBjaWJy
aWRnZV92ZW5kb3JzW3RtcF0pIHsKKwkJCQlwY2lwcml2LT5uZGlzX2FkYXB0ZXIucGNpYnJp
ZGdlX3ZlbmRvciA9IHRtcDsKKwkJCQlSVF9UUkFDRShydGxwcml2LCBDT01QX0lOSVQsIERC
R19ETUVTRywKKwkJCQkJICgiUGNpIEJyaWRnZSBWZW5kb3IgaXMgZm91bmQgaW5kZXg6Igor
CQkJCQkgIiAlZFxuIiwgdG1wKSk7CisJCQkJYnJlYWs7CisJCQl9CiAJCX0KIAl9CiAK
--------------060100060204010406060901--
