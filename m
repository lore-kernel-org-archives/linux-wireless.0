Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16535 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751243AbaHNIYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:24:21 -0400
From: Avinash Patil <patila@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 14 Aug 2014 01:23:15 -0700
Subject: RE: mwifiex: switching from adhoc to 5GHz managed fails
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147C18@SC-VEXCH2.marvell.com> (sfid-20140814_102434_573345_BF689198)
References: <CALtMJEDfVr1UxExOsiGK4G54BHB54wLt8co_98yZpFzH7NY9VA@mail.gmail.com>
	<CBACCFA0AEB13A41977475BCF3E896FC4781147BD9@SC-VEXCH2.marvell.com>,<CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com>
In-Reply-To: <CALtMJECey7bykvHp03-r1N=d774bOUyUagJqZAbZEeHwDPstew@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_CBACCFA0AEB13A41977475BCF3E896FC4781147C18SCVEXCH2marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_CBACCFA0AEB13A41977475BCF3E896FC4781147C18SCVEXCH2marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Andreas,

Please check if this diff file helps to resolve ibss issue.

Thanks,
Avinash.
________________________________________
From: Andreas Fenkart [afenkart@gmail.com]
Sent: Tuesday, August 12, 2014 4:28 AM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org
Subject: Re: mwifiex: switching from adhoc to 5GHz managed fails

Hi Avinash,

2014-08-08 14:51 GMT+02:00 Avinash Patil <patila@marvell.com>:
> Are you setting type back to managed after leaving ibss?
yes

> I quickly tried this in my setup and after setting type to managed before=
 connection to 5GHz AP, association is successful.

15ba2236f3556fc01b9ca91394465152b5ea74b6 Merge
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
9a3c4145af32125c5ee39c0272662b47307a8323 Linux 3.16-rc6

and latest commit in driver/net/wireless/mwifiex:
701a9e619347ac06d59481db14bbc4df99763270 mwifiex: initialize Tx/Rx
info of a packet correctly

Am I missing some patches?

> If I dont set type, I see error from iw itself "operation not supported".
I receive "ASSOC_RESP: failed:"

iw version : 3.13

--_002_CBACCFA0AEB13A41977475BCF3E896FC4781147C18SCVEXCH2marve_
Content-Type: text/x-patch; name="mwifiex_ibss_issue.diff"
Content-Description: mwifiex_ibss_issue.diff
Content-Disposition: attachment; filename="mwifiex_ibss_issue.diff"; size=746;
	creation-date="Thu, 14 Aug 2014 08:24:05 GMT";
	modification-date="Thu, 14 Aug 2014 08:24:05 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc3RhX2lvY3RsLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9td2lmaWV4L3N0YV9pb2N0bC5jCmluZGV4IGNhYWU5NzMuLjgw
MTZiYzIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvc3RhX2lvY3Rs
LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zdGFfaW9jdGwuYwpAQCAtMjg5
LDggKzI4OSwxMSBAQCBpbnQgbXdpZmlleF9ic3Nfc3RhcnQoc3RydWN0IG13aWZpZXhfcHJpdmF0
ZSAqcHJpdiwgc3RydWN0IGNmZzgwMjExX2JzcyAqYnNzLAogCQlpZiAobXdpZmlleF9iYW5kX3Rv
X3JhZGlvX3R5cGUoYnNzX2Rlc2MtPmJzc19iYW5kKSA9PQogCQkJCQkJSG9zdENtZF9TQ0FOX1JB
RElPX1RZUEVfQkcpCiAJCQljb25maWdfYmFuZHMgPSBCQU5EX0IgfCBCQU5EX0cgfCBCQU5EX0dO
OwotCQllbHNlCi0JCQljb25maWdfYmFuZHMgPSBCQU5EX0EgfCBCQU5EX0FOIHwgQkFORF9BQUM7
CisJCWVsc2UgeworCQkJY29uZmlnX2JhbmRzID0gQkFORF9BIHwgQkFORF9BTjsKKwkJCWlmIChh
ZGFwdGVyLT5md19iYW5kcyAmIEJBTkRfQUFDKQorCQkJCWNvbmZpZ19iYW5kcyB8PSBCQU5EX0FB
QzsKKwkJfQogCiAJCWlmICghKChjb25maWdfYmFuZHMgfCBhZGFwdGVyLT5md19iYW5kcykgJiB+
YWRhcHRlci0+ZndfYmFuZHMpKQogCQkJYWRhcHRlci0+Y29uZmlnX2JhbmRzID0gY29uZmlnX2Jh
bmRzOwo=

--_002_CBACCFA0AEB13A41977475BCF3E896FC4781147C18SCVEXCH2marve_--
