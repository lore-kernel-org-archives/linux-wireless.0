Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:44998 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936054Ab3DHORz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 10:17:55 -0400
Message-ID: <5162D18B.2040607@neratec.com> (sfid-20130408_161759_726590_BAB2816A)
Date: Mon, 08 Apr 2013 16:17:47 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2] mac80211: fix recalc_radar hwconf sync problem
References: <1365165364.8515.24.camel@jlt4.sipsolutions.net> <1365422997-15728-1-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1365422997-15728-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2013 02:09 PM, Simon Wunderlich wrote:
> local->hw.conf maybe not be synced when recalcing whether radar is
> enabled, sometimes leaving radar enabled even if it's not neccesary
> anymore.
> 
> Fix this by:
>  * setting radar_enabled when creating the chanctx
>  * turning radar_enabled off before destroying the last channel context
> 
> Reported-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---

Thanks, this one does what it should, so feel free to add

Tested-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
