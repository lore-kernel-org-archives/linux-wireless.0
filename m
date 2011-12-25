Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63183 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab1LYQ6s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Dec 2011 11:58:48 -0500
Received: by eekc4 with SMTP id c4so10631378eek.19
        for <linux-wireless@vger.kernel.org>; Sun, 25 Dec 2011 08:58:46 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [RFC] mac80211: use rcu_read_lock before sta_info_get
Date: Sun, 25 Dec 2011 17:58:40 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>, pstew@chromium.org,
	linux-wireless@vger.kernel.org
References: <1324825752-8186-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1324825752-8186-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201112251758.41131.chunkeey@googlemail.com> (sfid-20111225_175859_572785_9FD42B00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 December 2011 16:09:12 Mohammed Shafi Shajakhan wrote:
> @@ -1385,7 +1385,9 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
>  	struct sta_info *sta;
>  
>  	if (ifmgd->associated) {
> +		rcu_read_lock();
>  		sta = sta_info_get(sdata, ifmgd->bssid);
> +		rcu_read_unlock();
>  		if (sta)
>  			sta->beacon_loss_count++;
>  	}

uh, I think it should be:

> +		rcu_read_lock();
>  		sta = sta_info_get(sdata, ifmgd->bssid);
>  		if (sta)
>  			sta->beacon_loss_count++;
> +		rcu_read_unlock();

Since we update a member of the rcu-protected "sta"
reference.

Regards,
	Chr
