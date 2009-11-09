Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZKIXBq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:01:46 -0500
Subject: Re: [PATCH] iwlcore: Allow runtime configuration of
 no_sleep_autoadjust
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <andy@luto.us>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <cb0375e10911091447y375c276emddc5eff38b4b575e@mail.gmail.com>
References: <cb0375e10911081130k5d8f8347y999cf66a98e6898a@mail.gmail.com>
	 <1257787187.21134.22331.camel@rc-desk>
	 <cb0375e10911091007w45fa5653y8ed4f043f37074b6@mail.gmail.com>
	 <1257805265.21134.22738.camel@rc-desk>
	 <cb0375e10911091447y375c276emddc5eff38b4b575e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 15:01:40 -0800
Message-Id: <1257807700.21134.22787.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrew,

On Mon, 2009-11-09 at 14:47 -0800, Andrew Lutomirski wrote:
> On Mon, Nov 9, 2009 at 5:21 PM, reinette chatre
> <reinette.chatre@intel.com> wrote:
> > Hi Andrew,
> >
> > On Mon, 2009-11-09 at 10:07 -0800, Andrew Lutomirski wrote:
> >> Hmm.  It looks like sleep_level_override in debugfs can do exactly what I want.
> >
> > You have not really stated what you are trying to do here so it is hard
> > to tell. sleep_level_override lets you hardcode the power saving index.
> >
> >>
> >> Is there any reason that no_sleep_autoadjust doesn't just make
> >> sleep_level_override default to 1?
> >
> > That does seem what it is doing in iwl_power_update_mode().
> 
> I want to save power.  no_sleep_autoadjust=N and iwconfig wlan0 power
> on does a good job of that.  I assume that no_sleep_autoadjust
> defaults to Y because it's still not reliable (and I seem to have seen
> a few networks where it causes occasional problems).  So I'd like to
> be able to toggle it at runtime, file bug reports when it fails, but
> still be able to use the networks it fails on :)

Perhaps you could add a new debugfs file to modify no_sleep_autoadjust.
This will enable you to write the new power command to the device after
the setting has changed, similar to what is done in
iwl_dbgfs_sleep_level_override_write. This will ensure that your setting
takes effect at the time you make the change.

Reinette


