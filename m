Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:24207 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbYEUFxN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 01:53:13 -0400
Received: by yw-out-2324.google.com with SMTP id 9so1573710ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 22:53:00 -0700 (PDT)
Message-ID: <445f43ac0805202252v2fc8757ax5a43ddce8188ed61@mail.gmail.com> (sfid-20080521_075322_159194_0A23C88D)
Date: Tue, 20 May 2008 22:52:59 -0700
From: "Javier Cardona" <javier@cozybit.com>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	carrano@laptop.org, dwmw2@infradead.org, dilinger@queued.net
In-Reply-To: <200805201007.59746.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
	 <200805201007.59746.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger,

Thanks for your comments.

On Tue, May 20, 2008 at 1:07 AM, Holger Schurig
<hs4233@mail.mn-solutions.de> wrote:
> *) a runtime check (e.g. by comparing firmware version) if
>   the firmware supports mesh at all, and then doing this only
>   in that case. Probably as lbs_has_mesh() call, we're going
>   to need this in several places
>
> *) a kernel-config option, because many people use CF/SDIO
>   cards in embedded environmnents and like to have things
>   small. No need for #ifdef/#endif, because the compiler can
>   savely optimize things out: "#define lbs_has_mesh() (0)"
>   if mesh is turned off via Kconfig.

Is David's suggestion acceptable to you?

On Sat, 2008-05-17 at 21:01 -0700, David Woodhouse wrote:
> As Holger points out, we should call those only if (priv->mesh_tlv).

> Also, you create /sys/class/net/ethX/mesh_ie. This doesn't make
> sense to me. /sys/class/net/mshX/boot_options seems to be more
> logical. However, I don't know much about mesh ...

The entries in the mesh_ie directory groups the non-volatile
parameters of the mesh Information Element that is included in all
mesh beacons.

Javier

-- 
Javier Cardona
cozybit Inc.
