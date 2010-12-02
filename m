Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:6084 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751335Ab0LBBRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 20:17:08 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0387122623
	for <linux-wireless@vger.kernel.org>; Thu,  2 Dec 2010 10:17:06 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Javier Cardona <javier@cozybit.com>
Subject: Re: [PATCH 1/3] ath5k: Fix beaconing in mesh mode
Date: Thu, 2 Dec 2010 10:16:31 +0900
Cc: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com> <AANLkTin3G2=T_qMSQdvXgUShtVSpg+MeH4EZX10QU9OQ@mail.gmail.com> <AANLkTikNQitSrcj4Zn++BRAKp46hYTFb0tw61oD_bGVx@mail.gmail.com>
In-Reply-To: <AANLkTikNQitSrcj4Zn++BRAKp46hYTFb0tw61oD_bGVx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201012021016.31876.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu December 2 2010 03:23:07 Javier Cardona wrote:
> > Do you need to update the beacon this often or just once?
> > Adhoc doesn't need to do this, for example, because it doesn't
> > need the TIM; I don't know about mesh.
> 
> Currently power save mode is not implemented for mesh interfaces, so
> the TIM is not really updated or used.  But yes, in principle mesh
> beacons should include the TIM.  So it's better to use AP style
> beaconing to pave the way for someone implementing proper traffic info
> maps and power save for mesh.

I have been thinking the same. Using the same style beaconing for AP, ad-hoc 
and mesh mode could simplify the code, and make it easier to implement TIM or 
DFS later.

bruno
