Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm31-vm1.bullet.mail.ir2.yahoo.com ([212.82.97.88]:44797 "EHLO
        nm31-vm1.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761471AbcJ1QWf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Oct 2016 12:22:35 -0400
Date: Fri, 28 Oct 2016 16:15:48 +0000 (UTC)
From: Gianfranco Costamagna <locutusofborg@debian.org>
Reply-To: Gianfranco Costamagna <locutusofborg@debian.org>
To: "brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "nsmaldone@tierratelematics.com" <nsmaldone@tierratelematics.com>,
        "Marco.Arlone@roj.com" <Marco.Arlone@roj.com>
Message-ID: <690669269.1124561.1477671348137@mail.yahoo.com> (sfid-20161028_182252_519355_9D85DEED)
In-Reply-To: <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
References: <CACJOhtL-oFTJC5j0_+fdecWExZBKvDy13o+UBzw47tyrvD_SJQ@mail.gmail.com> <CACJOhtKej4EZ3ufGGUr=Rf1X=hufmKtPLQH3y4x0kK4nNg5U0w@mail.gmail.com>
Subject: [PATCH] broadcom/brcm80211/brcmfmac/cfg80211 driver, bad regulatory
 domain frequency value
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_Part_1124560_1470426816.1477671348137"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_1124560_1470426816.1477671348137
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(resending from my debian.org mail address, to avoid spam filtering)

Hi Broadcom developers and linux wireless list.

We found a possible issue in the cfg80211 implementation of the regulatory domain rules:

        .reg_rules = {
                /* IEEE 802.11b/g, channels 1..11 */
                REG_RULE(2412-10, 2472+10, 40, 6, 20, 0),


the referred channel 11 has/should have a frequency of 2462, not 2472 (corresponding to channel 13).
Is this a typo in the code or the above comment?

(I'm not sure why the override of reg.c is in place for 2.4 Ghz frequencies)

Can you please double check and in case apply the attached patch?

thanks,
-- 

Gianfranco Costamagna

------=_Part_1124560_1470426816.1477671348137
Content-Type: text/x-diff
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename*0=0001-broadcom-cfg80211-fix-regulatory-channel-frequency.patc;
	filename*1=h
Content-ID: <ead1f936-878c-f4ba-d890-84c8373e8fb4@yahoo.com>

RnJvbSBkYzJlYWViYThjZjNkOTkyYTE4NzQ1Y2ZlZjFiNzRiYmZjMTE3MTViIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcmxvbmUgTWFyY28gPG1hcmNvLmFybG9uZUByb2ouY29tPgpE
YXRlOiBTYXQsIDIyIE9jdCAyMDE2IDE1OjA4OjM1ICswMjAwClN1YmplY3Q6IFtQQVRDSF0gYnJv
YWRjb20gY2ZnODAyMTE6IGZpeCByZWd1bGF0b3J5IGNoYW5uZWwgZnJlcXVlbmN5IGNoYW5uZWwK
IDExIGlzIGFjdHVhbGx5IDI0NjIsIG5vdCAyNDcyICh0aGF0IGlzIGNoYW5uZWwgMTMgaW5zdGVh
ZCkKClNpZ25lZC1vZmYtYnk6IEdpYW5mcmFuY28gQ29zdGFtYWduYSA8Z2lhbmZyYW5jby5jb3N0
YW1hZ25hQGFiaW5zdWxhLmNvbT4KU2lnbmVkLW9mZi1ieTogQXJsb25lIE1hcmNvIDxtYXJjby5h
cmxvbmVAcm9qLmNvbT4KU2lnbmVkLW9mZi1ieTogTmljb2xhIFNtYWxkb25lIDxuaWNvbGEuc21h
bGRvbmVAdGllcnJhc2VydmljZS5jb20+CgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2Fk
Y29tL2JyY204MDIxMS9icmNtZm1hYy9jZmc4MDIxMS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NmZzgwMjExLmMgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYwppbmRl
eCBiNzc3ZTFiLi5kNzFmOTU5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9h
ZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYworKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2ZnODAyMTEuYwpAQCAtMjA0LDcgKzIw
NCw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiBicmNtZl9yZWdk
b20gPSB7CiAJLmFscGhhMiA9ICAiOTkiLAogCS5yZWdfcnVsZXMgPSB7CiAJCS8qIElFRUUgODAy
LjExYi9nLCBjaGFubmVscyAxLi4xMSAqLwotCQlSRUdfUlVMRSgyNDEyLTEwLCAyNDcyKzEwLCA0
MCwgNiwgMjAsIDApLAorCQlSRUdfUlVMRSgyNDEyLTEwLCAyNDYyKzEwLCA0MCwgNiwgMjAsIDAp
LAogCQkvKiBJZiBhbnkgKi8KIAkJLyogSUVFRSA4MDIuMTEgY2hhbm5lbCAxNCAtIE9ubHkgSlAg
ZW5hYmxlcwogCQkgKiB0aGlzIGFuZCBmb3IgODAyLjExYiBvbmx5Ci0tIAoyLjcuNAoK

------=_Part_1124560_1470426816.1477671348137--
