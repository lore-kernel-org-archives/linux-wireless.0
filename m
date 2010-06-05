Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab0FEAx4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 20:53:56 -0400
Subject: Re: [PATCH 0/3] Libertas : cfg80211, 11d support
From: Dan Williams <dcbw@redhat.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D627399A@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D627399A@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 17:54:06 -0700
Message-ID: <1275699246.2290.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-18 at 05:32 -0700, Kiran Divekar wrote:
> Add cfg80211 support to Libertas based on initial work from Holger Shurig.
> Add 11d support to Libertas.

Like John said, if you wouldn't mind rebasing, I'd love to get this in
even if there are a few regressions.  We need to move this forward to
cfg80211.

Thanks!
Dan

> Kiran Divekar (3):
>   Libertas: cfg80211 support
>   Libertas: fix WARN_ON issues in cfg80211 support
>   Libertas: Added 11d support using cfg80211
> 
>  drivers/net/wireless/libertas/Makefile  |    3 -
>  drivers/net/wireless/libertas/assoc.c   | 2264 -----------------------------
>  drivers/net/wireless/libertas/assoc.h   |  155 --
>  drivers/net/wireless/libertas/cfg.c     | 2038 ++++++++++++++++++++++++++-
>  drivers/net/wireless/libertas/cfg.h     |   21 +-
>  drivers/net/wireless/libertas/cmd.c     |   87 +-
>  drivers/net/wireless/libertas/cmdresp.c |   82 +-
>  drivers/net/wireless/libertas/debugfs.c |   54 +-
>  drivers/net/wireless/libertas/decl.h    |    8 +
>  drivers/net/wireless/libertas/dev.h     |   62 +-
>  drivers/net/wireless/libertas/ethtool.c |    5 -
>  drivers/net/wireless/libertas/host.h    |   28 +-
>  drivers/net/wireless/libertas/main.c    |  226 +---
>  drivers/net/wireless/libertas/rx.c      |  122 +--
>  drivers/net/wireless/libertas/scan.c    | 1354 ------------------
>  drivers/net/wireless/libertas/scan.h    |   63 -
>  drivers/net/wireless/libertas/tx.c      |   12 +-
>  drivers/net/wireless/libertas/wext.c    | 2353 -------------------------------
>  drivers/net/wireless/libertas/wext.h    |   17 -
>  19 files changed, 2237 insertions(+), 6717 deletions(-)
>  delete mode 100644 drivers/net/wireless/libertas/assoc.c
>  delete mode 100644 drivers/net/wireless/libertas/assoc.h
>  delete mode 100644 drivers/net/wireless/libertas/scan.c
>  delete mode 100644 drivers/net/wireless/libertas/scan.h
>  delete mode 100644 drivers/net/wireless/libertas/wext.c
>  delete mode 100644 drivers/net/wireless/libertas/wext.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


