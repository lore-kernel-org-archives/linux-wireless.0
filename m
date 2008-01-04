Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:7084 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYADFFi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2008 00:05:38 -0500
Received: by wa-out-1112.google.com with SMTP id v27so10212172wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jan 2008 21:05:37 -0800 (PST)
Message-ID: <cb0375e10801032105q5a6e6991t70e2d55743013662@mail.gmail.com> (sfid-20080104_050540_711641_79021C26)
Date: Thu, 3 Jan 2008 21:05:37 -0800
From: "Andrew Lutomirski" <luto@myrealbox.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] Respect fixed rates in rc80211_pid
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_4164_30876726.1199423137404"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_4164_30876726.1199423137404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[Attached b/c my mailer will screw it up]

rc80211_pid should respect fixed rates.

I would argue that mac80211 should handle fixed rates outside the rate
control code, which would also allow them to take effect immediately
instead of during the rate control callback, but this is pretty close
to correct.

Signed-Off-By: Andy Lutomirski <luto@myrealbox.com>

------=_Part_4164_30876726.1199423137404
Content-Type: text/x-patch; name=mac80211_rate_2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fb09k64n0
Content-Disposition: attachment; filename=mac80211_rate_2.patch

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9yYzgwMjExX3BpZF9hbGdvLmMgYi9uZXQvbWFjODAy
MTEvcmM4MDIxMV9waWRfYWxnby5jCmluZGV4IDYzMWU0NjguLmIyZDdkMTAgMTAwNjQ0Ci0tLSBh
L25ldC9tYWM4MDIxMS9yYzgwMjExX3BpZF9hbGdvLmMKKysrIGIvbmV0L21hYzgwMjExL3JjODAy
MTFfcGlkX2FsZ28uYwpAQCAtMTEwLDEwICsxMTAsNiBAQCBzdGF0aWMgdm9pZCByYXRlX2NvbnRy
b2xfcGlkX2FkanVzdF9yYXRlKHN0cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2FsLAogCWludCBi
YWNrID0gKGFkaiA+IDApID8gMSA6IC0xOwogCiAJc2RhdGEgPSBJRUVFODAyMTFfREVWX1RPX1NV
Ql9JRihzdGEtPmRldik7Ci0JaWYgKHNkYXRhLT5ic3MgJiYgc2RhdGEtPmJzcy0+Zm9yY2VfdW5p
Y2FzdF9yYXRlaWR4ID4gLTEpIHsKLQkJLyogZm9yY2VkIHVuaWNhc3QgcmF0ZSAtIGRvIG5vdCBj
aGFuZ2UgU1RBIHJhdGUgKi8KLQkJcmV0dXJuOwotCX0KIAogCW1vZGUgPSBsb2NhbC0+b3Blcl9o
d19tb2RlOwogCW1heHJhdGUgPSBzZGF0YS0+YnNzID8gc2RhdGEtPmJzcy0+bWF4X3JhdGVjdHJs
X3JhdGVpZHggOiAtMTsKQEAgLTI0Myw2ICsyMzksNyBAQCBzdGF0aWMgdm9pZCByYXRlX2NvbnRy
b2xfcGlkX3R4X3N0YXR1cyh2b2lkICpwcml2LCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogewog
CXN0cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2FsID0gd2Rldl9wcml2KGRldi0+aWVlZTgwMjEx
X3B0cik7CiAJc3RydWN0IGllZWU4MDIxMV9oZHIgKmhkciA9IChzdHJ1Y3QgaWVlZTgwMjExX2hk
ciAqKSBza2ItPmRhdGE7CisJc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGE7CiAJ
c3RydWN0IHJjX3BpZF9pbmZvICpwaW5mbyA9IHByaXY7CiAJc3RydWN0IHN0YV9pbmZvICpzdGE7
CiAJc3RydWN0IHJjX3BpZF9zdGFfaW5mbyAqc3BpbmZvOwpAQCAtMjUzLDYgKzI1MCwxMyBAQCBz
dGF0aWMgdm9pZCByYXRlX2NvbnRyb2xfcGlkX3R4X3N0YXR1cyh2b2lkICpwcml2LCBzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2LAogCWlmICghc3RhKQogCQlyZXR1cm47CiAKKwkvKiBEb24ndCB1cGRh
dGUgdGhlIHN0YXRlIGlmIHdlJ3JlIG5vdCBjb250cm9sbGluZyB0aGUgcmF0ZS4gKi8KKwlzZGF0
YSA9IElFRUU4MDIxMV9ERVZfVE9fU1VCX0lGKHN0YS0+ZGV2KTsKKwlpZiAoc2RhdGEtPmJzcyAm
JiBzZGF0YS0+YnNzLT5mb3JjZV91bmljYXN0X3JhdGVpZHggPiAtMSkgeworCQlzdGEtPnR4cmF0
ZSA9IHNkYXRhLT5ic3MtPm1heF9yYXRlY3RybF9yYXRlaWR4OworCQlyZXR1cm47CisJfQorCiAJ
LyogSWdub3JlIGFsbCBmcmFtZXMgdGhhdCB3ZXJlIHNlbnQgd2l0aCBhIGRpZmZlcmVudCByYXRl
IHRoYW4gdGhlIHJhdGUKIAkgKiB3ZSBjdXJyZW50bHkgYWR2aXNlIG1hYzgwMjExIHRvIHVzZS4g
Ki8KIAlpZiAoc3RhdHVzLT5jb250cm9sLnJhdGUgIT0gJmxvY2FsLT5vcGVyX2h3X21vZGUtPnJh
dGVzW3N0YS0+dHhyYXRlXSkK
------=_Part_4164_30876726.1199423137404--
