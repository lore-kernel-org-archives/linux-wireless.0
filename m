Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:55019 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYFDS5v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 14:57:51 -0400
Date: Wed, 4 Jun 2008 20:57:43 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: maximilian attems <max@stro.at>
Cc: linux-mm@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Page allocation failure in 2.6.26-rc2 (iwl4965 driver)
Message-ID: <20080604185743.GQ5012@ics.muni.cz> (sfid-20080604_205755_073376_FE13749C)
References: <20080604130307.GN5012@ics.muni.cz> <20080604130452.GD9258@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20080604130452.GD9258@baikonur.stro.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2008 at 03:04:52PM +0200, maximilian attems wrote:
> similar with 2.6.25-rc3-git7 not a regression. happens for me since
> early merge of iwlwifi after several resume and suspend cycles + mem
> pressure.

Jiri Slaby suggested that the iwl driver should not try to alloc 64kB (=
order
4) using kalloc but vmalloc should be used instead. While not understan=
ding
iwl driver internals, I cannot say whether it can be replaced per se.

--=20
Luk=E1=B9 Hejtm=E1nek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
