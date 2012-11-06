Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2KFWLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 17:11:36 -0500
Message-ID: <1352239931.8814.11.camel@jlt4.sipsolutions.net> (sfid-20121106_231147_981922_869C1F0C)
Subject: Re: minor bug on these three macros for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 06 Nov 2012 23:12:11 +0100
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10A9E@RockMX01.rock.corp> (sfid-20121106_224407_698078_277A6C5C)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C10A9E@RockMX01.rock.corp>
	 (sfid-20121106_224407_698078_277A6C5C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-06 at 21:43 +0000, Chaoxing Lin wrote:
> Net/mac80211/mesh_hwmp.c
> 
> #define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
> #define disc_timeout_jiff(s) \
>     msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
> #define root_path_confirmation_jiffies(s) \
>     msecs_to_jiffies(sdata->u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval)
> 
> 
> The "sdata" in these 3 macros should be "s".
> For now, code just happens to work since caller always passes in "sdata"

They should probably all just be static inlines, care to send a patch?

johannes

