Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36687 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbcGSNoF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:44:05 -0400
Received: by mail-qk0-f174.google.com with SMTP id x1so15743105qkb.3
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2016 06:44:04 -0700 (PDT)
Date: Tue, 19 Jul 2016 09:43:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: Re: [PATCH v2 2/3] mac80211: mesh: improve path resolving time
Message-ID: <20160719134355.GA1833@localhost> (sfid-20160719_154409_452359_7F22C0DD)
References: <CAEFj987X26u59K32Mt-bKBSTmy3cWvOiNNBG7K4wbdQBAdR97Q@mail.gmail.com>
 <20160719124456.GD11996@localhost>
 <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD110139206115@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 01:02:13PM +0000, Machani, Yaniv wrote:
> On Tue, Jul 19, 2016 at 15:44:56, Bob Copeland wrote:
> > > IEEE 802.11-2012 has defined dot11MeshHWMPpreqMinInterval attribute 
> > > to specify the minimum interval of time during which a mesh STA can 
> > > send only one Action frame containing a PREQ element. This is to 
> > > avoid flooding of broadcast PREQ frame especially when the number of 
> > > mesh STA is increased.
> > 
> > Good point, according to 13.10.9.3, conditions for sending PREQ include:
> > 
> > "The mesh STA has not sent a PREQ element for the target mesh STAs 
> > less than dot11MeshHWMPpreqMinInterval TUs ago. If this is the case, 
> > the transmission of the PREQ has to be postponed until this condition becomes true."
> > 
> 
> As I see it, the key point here is "for the target meh STA", 
> Today, the code will not send a PREQ to ANY target if
> dot11MeshHWMPpreqMinInterval didn't passed.
> The information is saved in the 'ifmsh->last_preq', and not per path.

The standard also says (which Chun-Yeow partially quoted):

dot11MeshHWMPpreqMinInterval OBJECT-TYPE
SYNTAX Unsigned32 (1..65535)
MAX-ACCESS read-write
STATUS current
DESCRIPTION
"This is a control variable.
It is written by an external management entity.
Changes take effect as soon as practical in the implementation.
This attribute specifies the minimum interval of time (in TUs) during
which a mesh STA can send only one Action frame containing a PREQ element."
DEFVAL { 100 }
::= { dot11MeshHWMPConfigEntry 4}

This wording seems to indicate that it is not per path.  Perhaps this
should be clarified in the standard.  (If the intent turns out to be per
path, then I guess we should fix it by storing last_preq per path instead.)

Ignoring the standard for a second, let's explore this: can you give
some idea on how many stations are in your target network, how frequently
a given pair of nodes unpeer, what sort of improvements you see with the
patch?  It should then be pretty easy to run some simulations to see the
scenarios where this helps and where it hurts.

-- 
Bob Copeland %% http://bobcopeland.com/
