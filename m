Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:53752 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935257Ab2JXRdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 13:33:23 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Thomas Pedersen <thomas@cozybit.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Javier Cardona" <javier@cozybit.com>
Subject: RE: 802.11s bug in ieee80211_rx_h_mesh_fwding() result in bogus MAC
 in mpp table
Date: Wed, 24 Oct 2012 17:33:19 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D075EC234@RockMX01.rock.corp> (sfid-20121024_193328_201351_3F329793)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D075EC214@RockMX01.rock.corp>
 <CAG6hwVNuijKqzNnyQMS9dxvRy3YdxuY_WkJ+k5L18yXc7jHe_Q@mail.gmail.com>
In-Reply-To: <CAG6hwVNuijKqzNnyQMS9dxvRy3YdxuY_WkJ+k5L18yXc7jHe_Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't know how to patch and submit.
Since the fix is simple, would you please patch it?

Chaoxing

> The cure is to move below early in this function when packet is encrypted.
>
> 1904     if (!(status->rx_flags & IEEE80211_RX_RA_MATCH))
> 1905         goto out;

Yes, I think it makes sense to put that check early in the function.
All forwarded frames need to pass that condition anyway.

Will you submit a proper patch for this?

Thomas
