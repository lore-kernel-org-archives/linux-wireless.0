Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:37503 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933AbYBZTZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 14:25:17 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1461803rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 11:25:13 -0800 (PST)
Subject: Re: [PATCH 06/10] mac80211: RCU-ify STA info structure access
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1204014238.13162.201.camel@johannes.berg>
References: <20080225152740.360393000@sipsolutions.net>
	 <20080225153007.340533000@sipsolutions.net>
	 <1203985337.6929.120.camel@localhost>
	 (sfid-20080226_002043_615849_4CE09F20)  <1204014238.13162.201.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 11:26:53 -0800
Message-Id: <1204054013.6947.18.camel@localhost> (sfid-20080226_192521_843411_4368D4BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-26 at 09:23 +0100, Johannes Berg wrote:
> I put a del_timer() into sta_info_unlink() and a del_timer_sync() into
> sta_info_destroy(). That should be enough afaict.

That is for the plink_timer in struct sta_info, if I understand
correctly. I am talking about the per mesh-path timer (the one in struct
mesh_path). 

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


