Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56428 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbcGSNCT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:02:19 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: RE: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
Date: Tue, 19 Jul 2016 13:02:13 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com> (sfid-20160719_150727_164213_2E59B379)
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost>
In-Reply-To: <20160719124456.GD11996@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 15:44:56, Bob Copeland wrote:
> Chun-Yeow Yeoh
> Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving 
> time
> 
> On Tue, Jul 19, 2016 at 12:59:56AM +0800, Chun-Yeow Yeoh wrote:
> > > To improve that, added an 'immediate' flag to be used when the 
> > > path needs
> to be resolved.
> > > Once set, a PREQ frame will be send w/o considering the 
> > > MinInterval
> parameter.
> >
> > Suggest that you try to reduce the mesh_hwmp_preq_min_interval to 
> > your desired value instead of introducing a new patch specific to 
> > your use case.
> >
> > IEEE 802.11-2012 has defined dot11MeshHWMPpreqMinInterval attribute 
> > to specify the minimum interval of time during which a mesh STA can 
> > send only one Action frame containing a PREQ element. This is to 
> > avoid flooding of broadcast PREQ frame especially when the number of 
> > mesh STA is increased.
> 
> Good point, according to 13.10.9.3, conditions for sending PREQ include:
> 
> "The mesh STA has not sent a PREQ element for the target mesh STAs 
> less than dot11MeshHWMPpreqMinInterval TUs ago. If this is the case, 
> the transmission of the PREQ has to be postponed until this condition becomes true."
> 

As I see it, the key point here is "for the target meh STA", 
Today, the code will not send a PREQ to ANY target if dot11MeshHWMPpreqMinInterval didn't passed.
The information is saved in the 'ifmsh->last_preq', and not per path.

Another point is, that this is a case where we had a valid path, but lost it due to our next hop peer disconnect.
Reducing the dot11MeshHWMPpreqMinInterval will just flood the network, 
Our goal is to improve the healing time, it's not a specific use case, it will improve network performance.

Thanks,
Yaniv

