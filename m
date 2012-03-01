Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:59964 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755082Ab2CACGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 21:06:19 -0500
Received: by obbta14 with SMTP id ta14so128455obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 18:06:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120216120303.GD25833@redhat.com>
References: <CAJZjf_y_fSYv0U8y8APLJAvWe=xKWpa_poLc9h7qjQuRSj_rGw@mail.gmail.com>
 <20120216120303.GD25833@redhat.com>
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Thu, 1 Mar 2012 02:05:58 +0000
Message-ID: <CAJZjf_x7+QLLh=KyDMuB9bWoXsoy8bFPp=PtWvz_qgNdVMwiww@mail.gmail.com> (sfid-20120301_030643_960721_D3DB9B93)
Subject: Re: iwl3945: WPA2+swcrypto=0: receives broadcast only
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: multipart/mixed; boundary=14dae93998f7dd997504ba24e7b4
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--14dae93998f7dd997504ba24e7b4
Content-Type: text/plain; charset=ISO-8859-1

Hi! inline :)

On Thu, Feb 16, 2012 at 12:03 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Feb 06, 2012 at 06:41:21PM +0000, Pedro Francisco wrote:
> > I'd present the debug of iwl3945 but apparently that option was
> > removed from iwl3945 module?
> ??? absolutily not, perhaps you did not compile CONFIG_IWLEGACY_DEBUG=y ?

Sorry, I got confused due to /boot/config-* (Fedora 16 here) having no
CONFIG_IWLEGACY_DEBUG= .

I've now understood the correct file [to check for iwl3945 config
options] was /boot/config.mk-compat-wireless-* .

I've applied the attached patch to the kernel SPEC+SOURCE combo and
will investigate the issue of WPA2 not working properly.

Thank you for your reply!

-- 
Pedro

--14dae93998f7dd997504ba24e7b4
Content-Type: text/x-patch; charset=US-ASCII; name="iwlegacyDebug-config-mk.patch"
Content-Disposition: attachment; filename="iwlegacyDebug-config-mk.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gz95gpj60

ZGlmZiAtLWdpdCBhL2NvbmZpZy5tayBiL2NvbmZpZy5tawppbmRleCA2NTAzYWUxLi5iM2Q4MmQ0
IDEwMDY0NAotLS0gYS9jb25maWcubWsKKysrIGIvY29uZmlnLm1rCkBAIC0zMDAsOCArMzAwLDgg
QEAgQ09ORklHX0lXTFdJRkk9bQogQ09ORklHX0lXTEVHQUNZPW0KIENPTkZJR19DT01QQVRfSVdM
NDk2NT1tCiBDT05GSUdfSVdMMzk0NT1tCi0jIENPTkZJR19JV0xFR0FDWV9ERUJVRz15Ci0jIENP
TkZJR19JV0xFR0FDWV9ERUJVR0ZTPXkKK0NPTkZJR19JV0xFR0FDWV9ERUJVRz15CitDT05GSUdf
SVdMRUdBQ1lfREVCVUdGUz15CiAKIAogQ09ORklHX0I0Mz1tCg==
--14dae93998f7dd997504ba24e7b4
Content-Type: text/x-patch; charset=US-ASCII; name="iwlegacyDebug-SPEC.patch"
Content-Disposition: attachment; filename="iwlegacyDebug-SPEC.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gz95hyzk1

ZGlmZiAtLWdpdCBhL1NQRUNTL2tlcm5lbC5zcGVjIGIvU1BFQ1Mva2VybmVsLnNwZWMKaW5kZXgg
ZDU5ZTU5Mi4uYTBlZGU4MCAxMDA2NDQKLS0tIGEvU1BFQ1Mva2VybmVsLnNwZWMKKysrIGIvU1BF
Q1Mva2VybmVsLnNwZWMKQEAgLTIzLDcgKzIzLDcgQEAgU3VtbWFyeTogVGhlIExpbnV4IGtlcm5l
bAogIwogIyAoVW5jb21tZW50IHRoZSAnIycgYW5kIGJvdGggc3BhY2VzIGJlbG93IHRvIHNldCB0
aGUgYnVpbGRpZC4pCiAjCi0jICUgZGVmaW5lIGJ1aWxkaWQgLmxvY2FsCislZGVmaW5lIGJ1aWxk
aWQgLmxvY2FsCiAjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjCiAKICMgVGhlIGJ1aWxkaWQgY2FuIGFsc28gYmUgc3BlY2lm
aWVkIG9uIHRoZSBycG1idWlsZCBjb21tYW5kIGxpbmUKQEAgLTgwOSw2ICs4MDksNyBAQCBQYXRj
aDIxMjM1OiBzY3NpLXNkX3JldmFsaWRhdGVfZGlzay1wcmV2ZW50LU5VTEwtcHRyLWRlcmVmLnBh
dGNoCiBQYXRjaDUwMDAwOiBjb21wYXQtd2lyZWxlc3MtY29uZmlnLWZpeHVwcy5wYXRjaAogUGF0
Y2g1MDAwMTogY29tcGF0LXdpcmVsZXNzLXByX2ZtdC13YXJuaW5nLWF2b2lkYW5jZS5wYXRjaAog
UGF0Y2g1MDAwMjogY29tcGF0LXdpcmVsZXNzLWludGVncmF0ZWQtYnVpbGQucGF0Y2gKK1BhdGNo
NTAwMDM6IGl3bGVnYWN5RGVidWcucGF0Y2gKIFBhdGNoNTAxMDA6IGNvbXBhdC13aXJlbGVzcy1y
dGw4MTkyY3UtRml4LVdBUk5JTkctb24tc3VzcGVuZC1yZXN1bWUucGF0Y2gKIAogIyBQZW5kaW5n
IHVwc3RyZWFtIGZpeGVzCkBAIC0xNTg2LDYgKzE1ODcsNyBAQCBjZCBjb21wYXQtd2lyZWxlc3Mt
JXtjd3ZlcnNpb259CiBBcHBseVBhdGNoIGNvbXBhdC13aXJlbGVzcy1jb25maWctZml4dXBzLnBh
dGNoCiBBcHBseVBhdGNoIGNvbXBhdC13aXJlbGVzcy1wcl9mbXQtd2FybmluZy1hdm9pZGFuY2Uu
cGF0Y2gKIEFwcGx5UGF0Y2ggY29tcGF0LXdpcmVsZXNzLWludGVncmF0ZWQtYnVpbGQucGF0Y2gK
K0FwcGx5UGF0Y2ggaXdsZWdhY3lEZWJ1Zy5wYXRjaAogCiBBcHBseVBhdGNoIGNvbXBhdC13aXJl
bGVzcy1ydGw4MTkyY3UtRml4LVdBUk5JTkctb24tc3VzcGVuZC1yZXN1bWUucGF0Y2gKIAo=
--14dae93998f7dd997504ba24e7b4--
