Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:44759 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692AbaCGUTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 15:19:52 -0500
Message-ID: <1394223589.16156.83.camel@joe-AO722> (sfid-20140307_211956_295468_F759C5AF)
Subject: Re: [PATCH v5 3/3] mac80211: allow reservation of a running chanctx
From: Joe Perches <joe@perches.com>
To: Luca Coelho <lrothc@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Fri, 07 Mar 2014 12:19:49 -0800
In-Reply-To: <1394174602.4192.7.camel@dubbel>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	 <1394017904-4012-4-git-send-email-luca@coelho.fi>
	 <CA+BoTQnXAjPRNLvEs3XrtGOBcayyOKHm74WSYMJh-MDuUxJKsA@mail.gmail.com>
	 <1394174602.4192.7.camel@dubbel>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 08:43 +0200, Luca Coelho wrote:
> On Wed, 2014-03-05 at 12:32 +0100, Michal Kazior wrote:
> > On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:
> > > With single-channel drivers, we need to be able to change a running
> > > chanctx if we want to use chanctx reservation.  Not all drivers may be
> > > able to do this, so add a flag that indicates support for it.
[]
> > > diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
[]
> > > @@ -162,6 +162,26 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
> > >         }
> > >  }
> > >
> > > +static bool ieee80211_chanctx_is_reserved(struct ieee80211_local *local,
> > > +                                    struct ieee80211_chanctx *ctx)
> > > +{
> > > +       struct ieee80211_sub_if_data *sdata;
> > > +       bool ret = false;
> > > +
> > > +       lockdep_assert_held(&local->chanctx_mtx);
> > > +       rcu_read_lock();
> > > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > > +               if (sdata->reserved_chanctx == ctx) {
> > > +                       ret = true;
> > > +                       goto out;
> > > +               }
> > > +       }
> > > +
> > > +out:
> > > +       rcu_read_unlock();
> > > +       return false;
> > 
> > `return ret` ;-)
> 
> Gack! I'll fix.

trivia: using break is more traditional

static bool ieee80211_chanctx_is_reserved(struct ieee80211_local *local,
					  struct ieee80211_chanctx *ctx)
{
	struct ieee80211_sub_if_data *sdata;
	bool reserved = false;

	lockdep_assert_held(&local->chanctx_mtx);

	rcu_read_lock();

	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
		if (sdata->reserved_chanctx == ctx) {
			reserved = true;
			break;
		}
	}

	rcu_read_unlock();

	return reserved;
}


