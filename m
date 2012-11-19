Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab2KSUcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:32:23 -0500
Message-ID: <1353357162.18299.32.camel@jlt4.sipsolutions.net> (sfid-20121119_213226_943989_1B7110A1)
Subject: Re: [RFC 05/14] mac80211: mesh power mode indication in transmitted
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Mon, 19 Nov 2012 21:32:42 +0100
In-Reply-To: <50AA9177.5030408@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	  <1353134886-13256-6-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353143459.9543.19.camel@jlt4.sipsolutions.net>
	 <50AA9177.5030408@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Sorry, I don't get that one. According to IEEE80211-2012 8.4.2.100 Mesh 
> Configuration element and 8.4.2.100.8 Mesh Capability, the capability 
> field is just u8.
> It is currently written as follows:
> 
> mesh.c : mesh_add_meshconf_ie
> 
> /* Mesh capability */
> *pos = MESHCONF_CAPAB_FORWARDING;
> *pos |= ifmsh->accepting_plinks ?
>      MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
> *pos++ |= ifmsh->adjusting_tbtt ?
>      MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
> 
> Should I change anything? Just move the enum?

Err, I misinterpreted the code, sorry. I would appreciate if you moved
it to ieee80211.h with all the other protocol definitions.

johannes

