Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f173.google.com ([209.85.210.173]:46876 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZFPTvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 15:51:42 -0400
Received: by yxe3 with SMTP id 3so160456yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 12:51:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245181069.21287.53.camel@johannes.local>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
	 <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
	 <1245178613.21287.45.camel@johannes.local>
	 <445f43ac0906161232x743d7ab9u2f36a5893240b789@mail.gmail.com>
	 <1245181069.21287.53.camel@johannes.local>
Date: Tue, 16 Jun 2009 12:51:44 -0700
Message-ID: <445f43ac0906161251v63d59cc1jd72bade62910d086@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Jun 16, 2009 at 12:37 PM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-16 at 12:32 -0700, Javier Cardona wrote:
>
>> There are some mesh parameters that you would probably want to be
>> uniform across the mesh network (timeouts, number of retries, etc).
>> But the only mesh parameter that would result in a different mesh
>> network is the mesh_id, and that's only settable when the mesh
>> interface is created.
>>
>> Do you have a specific configuration parameter in mind?
>
> No, I don't have any in mind. I wasn't aware that only the mesh_id
> defines the mesh, I was under the impression that more needs to match,
> as codified in mesh_matches_local().

In addition to the mesh id, a successful peering requires that peer
candidates use the same methods for path selection, congestion
control, synchronization and authentication.  None of these are
configurable via iw (essentially because only one single option for
each method is implemented).

Cheers,

Javier
