Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:34876 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HXLw6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Aug 2013 07:52:58 -0400
Message-ID: <1377345177.5589.3.camel@porter.coelho.fi> (sfid-20130824_135300_913247_AFFCE440)
Subject: Re: iwlwifi micorcode errors and hardware resets problems
From: Luca Coelho <luca@coelho.fi>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Sat, 24 Aug 2013 14:52:57 +0300
In-Reply-To: <20130823090821.GB2632@redhat.com>
References: <20130823090821.GB2632@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 11:08 +0200, Stanislaw Gruszka wrote:
> We have those bug reports on RH bugzilla, and various other iwlwifi
> problems, but those have some common scenario:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=979873
> https://bugzilla.redhat.com/show_bug.cgi?id=990536
> https://bugzilla.redhat.com/show_bug.cgi?id=994322
> https://bugzilla.redhat.com/show_bug.cgi?id=996502
> https://bugzilla.redhat.com/show_bug.cgi?id=969610
> https://bugzilla.redhat.com/show_bug.cgi?id=999053
> 
> First there is Microcode error or other firmware problem, what make we
> do iwl_trans_stop_device() which set trans->state to IWL_TRANS_NO_FW.
> If mac80211 has some pending works/timers i.e. ieee80211_sta_work(),
> it calls drv and we trigger on of those warnings
> 
>         WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
>                   "%s bad state = %d", __func__, trans->state);
> 
> on some trans operation.
> 
> I think this can be fixed by first do quiesce on mac80211 (for example
> by ieee80211_sta_quiesce() procedure, which I removed but can be added
> back) and then do iwlagn_prepare_restart() & ieee80211_restart_hw().
> 
> Though I'm not sure if it's worth to do this since those warnings are
> indicator for malfunctioning iwlwifi firmware (or driver not correctly
> communicating with firmware), which will be unnoticed if not reported
> automatically by tool like ABRT. But perhaps we could add WARN_ONCE on
> Microcode error condition ?

I think that, if the quiesce really helps with this, we should do it.
This WARN is a side-effect of the problem and not the problem itself.
If you want to catch the FW problem, there should be a WARN elsewhere.

I'm not saying that this WARN should be removed and I also think it's a
good idea to change it to WARN_ON_ONCE().  I just think that, if there's
anything the driver can do to keep things running nicely, we should do
it.

In any case, I'll leave this for Johannes, Emmanuel or some of the other
guys with more experience in iwlwifi to comment. ;)

--
Cheers,
Luca.

