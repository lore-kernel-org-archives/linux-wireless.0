Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYDRLPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 07:15:06 -0400
Subject: Re: [PATCH] libertas: Fix ethtool statistics
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <200804181149.41838.hs4233@mail.mn-solutions.de>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <200804181102.03107.hs4233@mail.mn-solutions.de>
	 <1208509888.9212.291.camel@pmac.infradead.org>
	 <200804181149.41838.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 12:15:02 +0100
Message-Id: <1208517302.9212.324.camel@pmac.infradead.org> (sfid-20080418_121515_509516_BCECF8B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-18 at 11:49 +0200, Holger Schurig wrote:
> > The code does 'if (ret) return;', because it has no option to
> > return an error.
> 
> I wrote "if (ret) return ret", not "if (ret) return;".

I know you did, but I don't know why. The lbs_ethtool_get_stats()
function returns void. Sebastian's patch which memsets it to zero makes
sense, but it can't return an error.

> I applied your second patch on top of the first one and now this 
> happens:
> 
> $ ethtool -S eth1
> ethtool -S eth1
> 
> Which seems much better. The ultimate patch would be to provide 
> the result of CMD_802_GET_LOG for ethX and the result from 
> CMD_ACT_MESH_GET_STATS for mshX devices.
> 
> So, if you combine both patches into one, I'd ACK from 
> the "firmware without mesh capabilities" perspective :-)

They're separate problems, really. With or without the patch I first
posted, you're getting crap back when you ask for statistics on a
non-mesh device. The second patch fixes that, and stands alone.

-- 
dwmw2

