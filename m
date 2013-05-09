Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60228 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab3EIQfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 12:35:07 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20875.53161.157603.680374@gargle.gargle.HOWL> (sfid-20130509_183512_151343_7ABBC33F)
Date: Thu, 9 May 2013 22:02:41 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: Cyril Segretain <cyrilseg@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Fun with QoS in AP mode.
In-Reply-To: <518BCE45.1060704@candelatech.com>
References: <5189DB72.3020809@candelatech.com>
	<20873.56643.216380.594657@gargle.gargle.HOWL>
	<518A6C21.5070408@candelatech.com>
	<20875.12412.946993.203664@gargle.gargle.HOWL>
	<518BB62D.9060108@candelatech.com>
	<CAJu560hVBcdJ67uNprj0TOY6rWNd-iT8f7QNaE64=ENz91yj6w@mail.gmail.com>
	<518BCE45.1060704@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> I suspect we need to set up rules with 'tc' and maybe iptables.
> 
> I'm not having any luck finding any examples out on the web, but
> surely the info is somewhere w/out having to fully understand 'tc'.

DSCP can be used...

Something like "iptables -t mangle -A OUTPUT -p tcp --dport 5005 -j DSCP --set-dscp-class "CS6""
(Change the class for other priorities).

Sujith
