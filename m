Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34000 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbcGNH4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2016 03:56:25 -0400
Received: by mail-pf0-f179.google.com with SMTP id h14so27316775pfe.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2016 00:56:25 -0700 (PDT)
Subject: Re: [PATCH 0/4 v1] Refactoring ieee80211_iface_work
To: Alex Briskin <br.shurik@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <ecb3e937-7fa9-f530-1b23-b793b86b1514@broadcom.com> (sfid-20160714_095629_190457_5BC0E482)
Date: Thu, 14 Jul 2016 09:56:19 +0200
MIME-Version: 1.0
In-Reply-To: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13-7-2016 22:19, Alex Briskin wrote:
> Hi All,
> This is my first patch(s).

Hi Alex,

As these patches are touching mac80211 it would be good to use
'mac80211: ' prefix.

> I've decided to refactor ieee80211_iface_work function and break it down
> to smaller better defined function.
> 
> I think these changes make the code much more readable and do not impose
> no overhead.
> 
> I've tested these patches with sparse and checkpatch.pl 
> 
> Function names might not be descriptive enough.
> Hope you find this useful.
> 
> Alex Briskin (4):
>   0) [28e464b19aaaba90c8946fb979b58709d55dffcf] 
> 	Added new function ieee80211_is_skb_handled_by_pkt_type and moved
> 	some code from ieee80211_iface_work to reduce complexity and 
> 	improve readability
> 
>   1) [486e3d5abb4dc6361cdd923254a2b68d43dcdaba]
> 	Refactored code in ieee80211_is_skb_handled_by_pkt_type.
> 	"if () {} else if ()" replaced by switch case. 

I would collapse these two patches in one patch.

>   2) [9ef2eab8e831420bc6748a4466ffa6b7a99bf447]
> 	Added new function ieee80211_is_handled_by_frame_control and moved
> 	some code from ieee80211_iface_work to it.
> 
>   3) [1de8cdf9a0c05c6a21d9e43e5b55862f6efcf450] 
> 	Added new function ieee80211_handle_by_vif_type with code from
> 	ieee80211_iface_work.
> 
> 	At this point ieee80211_iface_work seems to me much more readable
> 	and better understood. 

You are allowed to have an opinion :-) The function naming of the three
functions could be more consistent as you seem to drop a bit in every
patch, ie. is_skb_handled_by -> is_handled_by -> handle_by.

Regards,
Arend

>  net/mac80211/iface.c | 264 +++++++++++++++++++++++++++++----------------------
>  1 file changed, 150 insertions(+), 114 deletions(-)
> 
