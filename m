Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41523 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbZLCKDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:03:09 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/10] [PATCH] libertas: remove WEXT, add CFG80211
Date: Thu, 3 Dec 2009 11:02:24 +0100
Cc: Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@googlemail.com>
References: <20091202142555.654873300@gmail.com> <1259786749.17666.47.camel@localhost.localdomain>
In-Reply-To: <1259786749.17666.47.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912031102.24557.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can you please have a look at the "#ifdef TODO" in cmd.c?

On libertas+cfg80211, there's no priv->secinfo. And there's no 
way "to check for valid WPA/WPA2 group keys", at least not that 
I know off. Also I don't know what this code section does and 
how to do it better.

Maybe it tries to prevent sleeping between two consecute "set 
type X key" calls, but maybe we'd better use a 
priv->dont_sleep_now" flag for that, that we set and clear in 
lbs_cfg_add_key ?!?

-- 
http://www.holgerschurig.de
