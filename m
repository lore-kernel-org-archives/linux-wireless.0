Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:41438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715AbZLUQRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 11:17:35 -0500
Received: by fg-out-1718.google.com with SMTP id 22so2133796fge.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 08:17:34 -0800 (PST)
Subject: Re: o11s: Modularize Path Selection Protocol etc.
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Rui Paulo <rpaulo@gmail.com>
In-Reply-To: <4B2F9930.8070401@cosetrain.com>
Date: Mon, 21 Dec 2009 16:17:29 +0000
Cc: linux-wireless@vger.kernel.org
Message-Id: <7057634E-E560-413E-9FB2-163F5311E054@gmail.com>
References: <4B2F9930.8070401@cosetrain.com>
To: Florian Sesser <flomaillist@cosetrain.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 Dec 2009, at 15:50, Florian Sesser wrote:

> Hi mesh folks!
> 
> For my diploma thesis, I want to add a P2P routing protocoll to the
> pre-80211s software in the linux kernel. For details, see my previous
> mails. [1],[2]
> 
> In struct ieee80211_if_mesh, the current code reads
> 
> net/mac80211/ieee80211_i.h
>>        u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
>>        size_t mesh_id_len;
>>        /* Active Path Selection Protocol Identifier */
>>        u8 mesh_pp_id;
>>        /* Active Path Selection Metric Identifier */
>>        u8 mesh_pm_id;
>>        /* Congestion Control Mode Identifier */
>>        u8 mesh_cc_id;
>>        /* Synchronization Protocol Identifier */
>>        u8 mesh_sp_id;
>>        /* Authentication Protocol Identifier */
>>        u8 mesh_auth_id;
> 
> which is what I at first wanted to work with.
> 
> In my last patch [2], I introduced some new 32 bit struct members,
> because, if I am not mistaken, these IDs should include a vendor
> specific OUI, which enables a user to combine a path selection protocol
> of vendor A with a path selection metric of vendor B.

This has changed quite a bit on the latest 802.11s draft standards. If you want to use your own routing protocol and to be 802.11s compliant, you need to set the path selection protocol ID to 255 and append a vendor specific information element to the management frame.

> 
> So.. am I erring here?
> 
> If yes, I would introduce a new 24 bit value for the OUI, which will be
> combined with all the above u8's before going over the wire (into the
> air of course)
> ...if no, I would replace those values by 32 bit ones, possibly even
> braking ABI compatibility.
> 
> What do you think?
> Do you maybe have a better suggestion?
> 
> Thank you very much for your input!
> 
> 
> Florian
> 
> [1] http://marc.info/?l=linux-wireless&m=122600107811517&w=2
> [2] http://marc.info/?l=linux-wireless&m=123300309207545&w=2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Rui Paulo

