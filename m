Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:36290 "EHLO
	mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbcGSMpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 08:45:05 -0400
Received: by mail-qt0-f182.google.com with SMTP id 52so8266674qtq.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 05:45:05 -0700 (PDT)
Date: Tue, 19 Jul 2016 08:44:56 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Yaniv Machani <yanivma@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Maital Hahn <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
Message-ID: <20160719124456.GD11996@localhost> (sfid-20160719_144513_593777_49BE0A5A)
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 12:59:56AM +0800, Chun-Yeow Yeoh wrote:
> > To improve that, added an 'immediate' flag to be used when the path needs to be resolved.
> > Once set, a PREQ frame will be send w/o considering the MinInterval parameter.
> 
> Suggest that you try to reduce the mesh_hwmp_preq_min_interval to your
> desired value instead of introducing a new patch specific to your use
> case.
> 
> IEEE 802.11-2012 has defined dot11MeshHWMPpreqMinInterval attribute to
> specify the minimum interval of time during which a mesh STA can send
> only one Action frame containing a PREQ element. This is to avoid
> flooding of broadcast PREQ frame especially when the number of mesh
> STA is increased.

Good point, according to 13.10.9.3, conditions for sending PREQ include:

"The mesh STA has not sent a PREQ element for the target mesh STAs less
than dot11MeshHWMPpreqMinInterval TUs ago. If this is the case, the
transmission of the PREQ has to be postponed until this condition becomes
true."

Adopting this patch would violate that, so please disregard my suggested
rewrites; we should just skip this one.

-- 
Bob Copeland %% http://bobcopeland.com/
