Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m-04.th.seeweb.it ([217.64.195.227]:60331 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab0APVm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 16:42:26 -0500
Date: Sat, 16 Jan 2010 22:35:38 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix sign error in pid controller
Message-ID: <20100116223538.57b69df3@vaiolo.stefanobrivio.net>
In-Reply-To: <1263670613-10864-2-git-send-email-me@bobcopeland.com>
References: <1263670613-10864-1-git-send-email-me@bobcopeland.com>
	<1263670613-10864-2-git-send-email-me@bobcopeland.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 16 Jan 2010 14:36:52 -0500
Bob Copeland <me@bobcopeland.com> wrote:

> While testing the pid rate controller in mac80211_hwsim, I noticed
> that once the controller reached 54 Mbit rates, it would fail to
> lower the rate when necessary.  The debug log shows:
> 
> 1945 186786 pf_sample 50 3534 3577 50
> 
> My interpretation is that the fixed point scaling of the target
> error value (pf) is incorrect: the error value of 50 compared to
> a target of 14 case should result in a scaling value of
> (14-50) = -36 * 256 or -9216, but instead it is (14 * 256)-50, or
> 3534.

Good catch! I actually wonder why nobody hit this before. One possible
explanation is that the proportional error alone, in most cases, isn't
significant "enough" with regard to the other ones.

Mattias, could you please double check this anyway?

> Cc: stefano.brivio@polimi.it
> Cc: mattias.nissler@gmx.de
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Acked-by: Stefano Brivio <stefano.brivio@polimi.it>


--
Ciao
Stefano
