Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15485 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbYDRJwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 05:52:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Date: Fri, 18 Apr 2008 11:49:41 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1208448814.9212.270.camel@pmac.infradead.org> <200804181102.03107.hs4233@mail.mn-solutions.de> <1208509888.9212.291.camel@pmac.infradead.org>
In-Reply-To: <1208509888.9212.291.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200804181149.41838.hs4233@mail.mn-solutions.de> (sfid-20080418_105252_441696_42353FD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Now at least it's _trying_ to get the stats :)

Yeah, but it shouldn't. You can test the mesh capability of the 
hardware (explizitly or implicitly via priv->mesh_dev != NULL) 
and you should only issue mesh commands if the hardware can do 
it.



> You were getting that anyway.

Right :-)

> > That ethtool returns junk like "9223372036854775808" is
> > another error. lbs_mesh_access() returned 2, and the code
> > does "if (ret) return ret". Maybe it should be like "if
> > (ret) return -ENOSYS (or some other ENOxxx) instead?
>
> The code does 'if (ret) return;', because it has no option to
> return an error.

I wrote "if (ret) return ret", not "if (ret) return;".

Anyway I think that returning something positive in the error 
case here seems wrong. However, I'm only thinking this, I 
haven't checked the ethtool interface/documentation of the 
kernel.



I applied your second patch on top of the first one and now this 
happens:

$ ethtool -S eth1
ethtool -S eth1

Which seems much better. The ultimate patch would be to provide 
the result of CMD_802_GET_LOG for ethX and the result from 
CMD_ACT_MESH_GET_STATS for mshX devices.

So, if you combine both patches into one, I'd ACK from 
the "firmware without mesh capabilities" perspective :-)
