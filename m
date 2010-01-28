Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51403.mail.re2.yahoo.com ([206.190.38.182]:33816 "HELO
	web51403.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752925Ab0A1IV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 03:21:56 -0500
Message-ID: <470500.11306.qm@web51403.mail.re2.yahoo.com>
Date: Thu, 28 Jan 2010 00:21:55 -0800 (PST)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: Re: mac80211: Open bug in current wireless-testing
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
In-Reply-To: <43e72e891001271012r60356d85k60fe55fbb027aa40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis, Jouni,
I found and read the patch in question. If I understand things correctly,
this provides a way to set a mask that marks the data rates that are
available for the RC algorithm to choose from. This could be translated 
into an iw command like this:

iw dev wlan0 rates 54M,11M

and then the current RC algorithm would be limited to choose either 54M or
11M as TX data rate. Is this correct?

Selecting a single fixed data rate would mean to only mark one data rate 
as available. I think this meats my requirements in this area. However,
I still have another problem: We use Madwifi to multicast video streams.

With Madwifi we have an iwpriv call that allows the selection of the multicast/broadcast data rate. We need something equivalent for mac80211
before we can make the switch.

-- 
Regards
       Joerg


--- Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Von: Luis R. Rodriguez <mcgrof@gmail.com>
> Betreff: Re: mac80211: Open bug in current wireless-testing
> An: "Joerg Pommnitz" <pommnitz@yahoo.com>
> CC: linux-wireless@vger.kernel.org, "Jouni.Malinen" <Jouni.Malinen@atheros.com>
> Datum: Mittwoch, 27. Januar 2010, 19:12
> On Wed, Jan 27, 2010 at 6:17 AM,
> Joerg Pommnitz <pommnitz@yahoo.com>
> wrote:
> > Hello all,
> > some time ago I reported that it is currently
> impossible to change a manually selected data rate back to
> the automatic rate selection. This bug is still present and
> is easy to reproduce:
> >
> > iwconfig wlan0 rate 54M
> > iwconfig wlan0 rate auto
> >
> > I know that the wireless extensions are deprecated,
> but until iw supports manual rate selection, iwconfig is
> what I have to use.
> 
> Review the patch:
> 
> Author: Jouni Malinen <jouni.malinen@atheros.com>
> Date:   Tue Dec 29 12:59:45 2009 +0200
> 
>     nl80211: New command for setting TX rate mask
> for rate control
> 
>     Add a new NL80211_CMD_SET_TX_BITRATE_MASK
> command and related
>     attributes to provide support for setting TX
> rate mask for rate
>     control. This uses the existing cfg80211
> set_bitrate_mask operation
>     that was previously used only with WEXT
> compat code (SIOCSIWRATE). The
>     nl80211 command allows more generic
> configuration of allowed rates as
>     a mask instead of fixed/max rate.
> 
>     Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>     Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> I think that addresses this, not sure if we ever got the iw
> equivalent
> patches to let userspace use this yet.
> 
> There are however three wext things which we still do need
> implement to nl80211:
> 
> iwconfig wlan0 txpower 17 # sets TX output power to 17 dBm
> iwconfig wlan0 power off # disables power save
> iwconfig wlan0 power 500m # enables dynamic power wave with
> 500ms idle
> timeout trigger
> 
> I've stuffed this int our todo list [1], if you confirm
> that the above
> patch does not yet address what you wish please add it to
> the todo
> list.
> 
> http://wireless.kernel.org/en/developers/todo-list
> 
>   Luis
> 

__________________________________________________
Do You Yahoo!?
Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails. 
http://mail.yahoo.com 
