Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:47028 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932950Ab3GLNSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 09:18:35 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Daniel Drake' <dsd@laptop.org>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 12 Jul 2013 06:14:31 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951035636368@SC-VEXCH1.marvell.com> (sfid-20130712_151839_969964_B1F85F37)
In-Reply-To: <CAMLZHHSFEoOJ3W+nyJUqzGTKy=8TEB6mSibrXN6ze1xzGHv35Q@mail.gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_5FF020A1CFFEEC49BD1E09530C4FF5951035636368SCVEXCH1marve_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951035636368SCVEXCH1marve_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

> Hmm. Now that I heard back from you and Bing, that interrupts at this
> point are totally unexpected, I would prefer to see the interrupt
> handler being disabled at the appropriate time, I think we can do
> better than my original patch. Let me see if I can find some time
> today/tomorrow to explore a better approach.

>What about this one?

The patch looks fine to me.
Some comments
1) Unused HOST_INT_DISABLE macro can be removed now.
2) if_ops.disable_int() should be called before if_ops.unregister_dev() eve=
n in driver load failure code path. Otherwise we will miss to release sdio =
irq in this case.
(You can consider applying attached changes on top of your patch for (1) an=
d (2))

3) Previously we used to have error handling for sdio_claim_irq(). Now we s=
hould check return status of if_ops.enable_int(). As I have couple of other=
 patches to handle driver load failure paths correctly, I will take care of=
 this separately.

4) I will create separate patch to avoid forward declaration of mwifiex_sdi=
o_interrupt() by moving some code.

Regards,
Amitkumar Karwar=20

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951035636368SCVEXCH1marve_
Content-Type: application/octet-stream; name="minor_corrections.diff"
Content-Description: minor_corrections.diff
Content-Disposition: attachment; filename="minor_corrections.diff"; size=1353;
	creation-date="Fri, 12 Jul 2013 12:43:49 GMT";
	modification-date="Fri, 12 Jul 2013 12:43:49 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZpZXgvbWFpbi5jIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMKaW5kZXggMjA4M2NmOC4uMjg2MTdkNiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMKKysrIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvbXdpZmlleC9tYWluLmMKQEAgLTQ4Miw2ICs0ODIsOCBAQCBlcnJfYWRk
X2ludGY6CiAJbXdpZmlleF9kZWxfdmlydHVhbF9pbnRmKGFkYXB0ZXItPndpcGh5LCBwcml2LT53
ZGV2KTsKIAlydG5sX3VubG9jaygpOwogZXJyX2luaXRfZnc6CisJaWYgKGFkYXB0ZXItPmlmX29w
cy5kaXNhYmxlX2ludCkKKwkJYWRhcHRlci0+aWZfb3BzLmRpc2FibGVfaW50KGFkYXB0ZXIpOwog
CXByX2RlYnVnKCJpbmZvOiAlczogdW5yZWdpc3RlciBkZXZpY2VcbiIsIF9fZnVuY19fKTsKIAlh
ZGFwdGVyLT5pZl9vcHMudW5yZWdpc3Rlcl9kZXYoYWRhcHRlcik7CiBkb25lOgpAQCAtODc0LDYg
Kzg3Niw4IEBAIG13aWZpZXhfYWRkX2NhcmQodm9pZCAqY2FyZCwgc3RydWN0IHNlbWFwaG9yZSAq
c2VtLAogCXJldHVybiAwOwogCiBlcnJfaW5pdF9mdzoKKwlpZiAoYWRhcHRlci0+aWZfb3BzLmRp
c2FibGVfaW50KQorCQlhZGFwdGVyLT5pZl9vcHMuZGlzYWJsZV9pbnQoYWRhcHRlcik7CiAJcHJf
ZGVidWcoImluZm86ICVzOiB1bnJlZ2lzdGVyIGRldmljZVxuIiwgX19mdW5jX18pOwogCWlmIChh
ZGFwdGVyLT5pZl9vcHMudW5yZWdpc3Rlcl9kZXYpCiAJCWFkYXB0ZXItPmlmX29wcy51bnJlZ2lz
dGVyX2RldihhZGFwdGVyKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL213aWZp
ZXgvc2Rpby5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmgKaW5kZXggNmQ1
MWRmZC4uNTMyYWUwYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9z
ZGlvLmgKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbXdpZmlleC9zZGlvLmgKQEAgLTkyLDkg
KzkyLDYgQEAKIC8qIEhvc3QgQ29udHJvbCBSZWdpc3RlcnMgOiBEb3dubG9hZCBob3N0IGludGVy
cnVwdCBtYXNrICovCiAjZGVmaW5lIEROX0xEX0hPU1RfSU5UX01BU0sJCSgweDJVKQogCi0vKiBE
aXNhYmxlIEhvc3QgaW50ZXJydXB0IG1hc2sgKi8KLSNkZWZpbmUJSE9TVF9JTlRfRElTQUJMRQkJ
MHhmZgotCiAvKiBIb3N0IENvbnRyb2wgUmVnaXN0ZXJzIDogSG9zdCBpbnRlcnJ1cHQgc3RhdHVz
ICovCiAjZGVmaW5lIEhPU1RfSU5UU1RBVFVTX1JFRwkJMHgwMwogLyogSG9zdCBDb250cm9sIFJl
Z2lzdGVycyA6IFVwbG9hZCBob3N0IGludGVycnVwdCBzdGF0dXMgKi8K

--_002_5FF020A1CFFEEC49BD1E09530C4FF5951035636368SCVEXCH1marve_--
