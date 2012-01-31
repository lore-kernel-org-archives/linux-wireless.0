Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:37960 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810Ab2AaKB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 05:01:56 -0500
Received: by mail-lpp01m020-f169.google.com with SMTP id gg6so578944lbb.14
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 02:01:54 -0800 (PST)
Subject: Re: [PATCH v2 01/10] wl12xx: fw api change - add role_id to
 set_template
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328003845-3926-2-git-send-email-eliad@wizery.com>
References: <1328003845-3926-1-git-send-email-eliad@wizery.com>
	 <1328003845-3926-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Jan 2012 12:01:51 +0200
Message-ID: <1328004111.3626.159.camel@cumari> (sfid-20120131_110159_485396_A50FD6D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 11:57 +0200, Eliad Peller wrote: 
> The set_template commands now takes the role_id as
> parameter.
> 
> Usually, we'll use the vif's main role_id.
> However, sometimes we'll want to use
> wlvif->dev_role_id instead of wlvif->role_id,
> so pass the wanted role_id as param.
> 
> Update WL127X_FW_NAME/WL128X_FW_NAME.
> 
> (This commit starts a series of fw update patches,
> and changes the start() callback to return an error
> in order to prevent the use of the driver during the
> transition. This change will be reverted in the
> last patch of series)

Is it really necessary to prevent boot until the last patch in this
series? Is the PS stuff really mandatory? I was thinking that after 4/10
we could already re-enable it.


> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v2: return -EBUSY on start(), commit message

-EBUSY? Maybe -EOPNOTSUPP would be better? -EBUSY usually means that you
should try again later.  But never mind, this is just a transition phase
anyway. ;)

-- 
Cheers,
Luca.

