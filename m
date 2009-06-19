Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:46478 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbZFSRAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:00:55 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1043453ywb.1
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:00:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3B5B11.7060103@bitnet.be>
References: <4A3B5B11.7060103@bitnet.be>
Date: Fri, 19 Jun 2009 10:00:57 -0700
Message-ID: <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com>
Subject: Re: current status of 802.11s mesh in ath5k ?
From: Andrey Yurovsky <andrey@cozybit.com>
To: Hans Maes <Hans@bitnet.be>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 2:32 AM, Hans Maes<Hans@bitnet.be> wrote:
> What is the status of 802.11s mesh support in ath5k in the 2.6.30 kernel, in
> the current wireless-compat, and in the current wireless-testing ?
> Does it work, or is it broken ?

You'll want wireless-testing (or the latest compat), after commit
41ba08509.  However ath5k will not beacon until you issue a scan due
to a bug.  You can bring up an ath5k node like this:

# iw phy phy0 interface add mesh type mp mesh_id mymesh
# ifconfig mesh up
# iwlist mesh scan

> Can/should it be used in a production environment ?

Things seem to work well aside from the scan issue, however I haven't
fully verified multi-hop yet.  802.11s is currently a draft and the
mac80211 implementation does not implement the full draft at this
time.

> Also, what is the best place to track the status/progress on 802.11s mesh in
> ath5k ?

We're keeping the mesh-specific drivers list up to date here:
http://o11s.org/trac
...however you may also be interested in the ath5k mailing list or the
open80211s mailing list.  Debugging effort and patches to resolve the
scan issue or any other ath5k issues are very much welcome!  Thanks,

  -Andrey

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
