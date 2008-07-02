Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYGBRES (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2008 13:04:18 -0400
Subject: Re: Question on rfkill double block
From: Dan Williams <dcbw@redhat.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1214982208.14590.473.camel@debian.sh.intel.com>
References: <1214982208.14590.473.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 02 Jul 2008 13:03:09 -0400
Message-Id: <1215018189.29117.32.camel@localhost.localdomain> (sfid-20080702_190435_432184_703EC12B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-02 at 15:03 +0800, Zhu Yi wrote:
> Hi,
>=20
> Quote from Documentation/rfkill.txt:
> "
> The driver should implement the toggle_radio() hook, that:
>=20
> ...
>=20
> 3. Deactivates the soft rfkill line if none of the hardware rfkill li=
nes
> are active and the caller asked for RFKILL_STATE_UNBLOCKED.
> "
>=20
> It doesn't say what to do if both the hardware and software rfkill li=
nes
> are active when RFKILL_STATE_UNBLOCKED is asked. Should we deactivate
> the software rfkill in this case? Otherwise below usage won't turn on
> the radio:
>=20
> hardware rfkill activate
> software rfkill activate
> RFKILL_STATE_UNBLOCKED request
> hardware rfkill deactivate
>=20
> Furthermore, if we permit double block, what should get_state() retur=
n?
> Shouldn't rfkill_state =EF=BB=BFbe bitmap instead of enum?

That would be more useful than the current enum, yes.

Dan


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
