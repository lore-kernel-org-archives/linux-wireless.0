Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1IEJdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 05:33:42 -0400
Date: Mon, 5 Sep 2011 11:33:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110905093349.GE2221@redhat.com> (sfid-20110905_113346_408359_1AEFB487)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <201106070832.49048.bschmidt@freebsd.org>
 <20110607145435.GA5179@redhat.com>
 <1315124915.5239.21.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315124915.5239.21.camel@x61.thuisdomein>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 04, 2011 at 10:28:35AM +0200, Paul Bolle wrote:
> On Tue, 2011-06-07 at 16:54 +0200, Stanislaw Gruszka wrote:
> > That could be useful hint, we do not scan chan by chan, but we
> > have thing called "plcp check health", which "restart radio"
> > by requesting one channel scan. So perhaps disabling that could
> > help.
> > 
> > [...]
> >
> > diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
> > index 654cf23..6062da0 100644
> > --- a/drivers/net/wireless/iwlegacy/iwl-rx.c
> > +++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
> > @@ -230,6 +230,8 @@ EXPORT_SYMBOL(iwl_legacy_rx_spectrum_measure_notif);
> >  void iwl_legacy_recover_from_statistics(struct iwl_priv *priv,
> >  				struct iwl_rx_packet *pkt)
> >  {
> > +	return;
> > +
> >  	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> >  		return;
> >  	if (iwl_legacy_is_any_associated(priv)) {
> 
> 0) I finally got around to applying this patch (to v3.0.4).
> 
> 1) After a few days of normal usage (with quite a bit of suspend and
> resume cycles) this error was again triggered. So avoiding
> check_plcp_health() doesn't seem to help.
> 
> 2) I never send you the debug output (ie, output after doing "modprobe
> iwl4965 debug=0x47ffffff"), did I?

No, but if error show up after few days, gathering and analyzing few
days of debug logs in impractical. Does wifi stop working after an
error, or there is some other negative impact? Or only that messages
are printed and driver recover itself?

Stanislaw
