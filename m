Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbXGSUCC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 16:02:02 -0400
Subject: Re: libertas warnings & bugs
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1184767237.11352.2.camel@johannes.berg>
References: <1184767237.11352.2.camel@johannes.berg>
Content-Type: text/plain; charset=utf-8
Date: Thu, 19 Jul 2007 16:00:44 -0400
Message-Id: <1184875244.3179.30.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-07-18 at 16:00 +0200, Johannes Berg wrote:
> Hi Dan,
>=20
> As promised a few more warnings from libertas from my ppc64 build.
>=20
> drivers/net/wireless/libertas/cmd.c: In function =E2=80=98wlan_cmd_80=
2_11_set_wep=E2=80=99:
> drivers/net/wireless/libertas/cmd.c:189: warning: large integer impli=
citly truncated to unsigned type
> drivers/net/wireless/libertas/cmd.c:195: warning: large integer impli=
citly truncated to unsigned type

=46ixed this one.

> The code is:
> wep->keytype[i] =3D cpu_to_le16(cmd_type_wep_40_bit);
>=20
> and it's fairly obvious why it warns: keytype[i] is a u8 so always en=
ds
> up 0...
>=20
> drivers/net/wireless/libertas/debugfs.c: In function =E2=80=98liberta=
s_getscantable=E2=80=99:
> drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98=
%08llx=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, =
but argument 4 has type =E2=80=98u64=E2=80=99
> drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98=
%08llx=E2=80=99 expects type =E2=80=98long long unsigned int=E2=80=99, =
but argument 4 has type =E2=80=98u64=E2=80=99
>=20
> probably just needs a cast to unsigned long long.

You probably want the 'libertas' branch, where this one doesn't
appear...  master is plain linus kernels.  The layout was suggested by
linville but maybe it's confusing?

Dan


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
