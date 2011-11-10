Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49912 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab1KJMoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 07:44:10 -0500
Subject: rewriting powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 13:44:05 +0100
Message-ID: <1320929045.3967.52.camel@jlt3.sipsolutions.net> (sfid-20111110_134417_015524_7F885E2A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

Let's more seriously think about rewriting powersave. We need to be able
to handle multi-vif powersave, and nobody even claims to understand the
current code any more, let alone knows how to fix the bugs in it.

We have three flags:
* IEEE80211_HW_SUPPORTS_PS
* IEEE80211_HW_PS_NULLFUNC_STACK
* IEEE80211_HW_SUPPORTS_DYNAMIC_PS
but obviously not all combinations make sense. The valid combinations
are:

1) !SUPPORTS_PS (d'oh)
2) SUPPORTS_PS
3) SUPPORTS_PS | NULLFUNC_STACK
4) SUPPORTS_PS | SUPPORTS_DYNAMIC_PS

The drivers seem to use them:
1) didn't check, probably plenty
2) wl1251, wl12xx (though the latter is moving to 4) I believe)
3) ath9k_htc, ath9k, carl9170, p54, rt2x00, rtlwifi
4) iwlwifi, iwlegacy

So by far the most common are 1 and 3, with 2 being a dying breed and 4
being obviously trivial.


The interesting thing here is that the difference between 2 and 3 is
relatively small, except for the off-channel case where case 2 is really
confusing. But wl1251 has hardware scan, so we don't have to worry about
that all that much. (The auth/assoc work case is curious but I think we
need to do that differently soon enough anyway)

Since clearly it is possible to implement this in the lower layers, I'm
thinking we should provide an implementation that the drivers can use to
implement powersave and be in category 4 from mac80211's POV.

I think the API for case 3 could look something like this:

struct powersave {
	...
};

struct powersave_ops {
	void (*tx_nulldata)(void *ctx, ...);
	void (*set_radio)(void *ctx, bool on);
	void (*timeout_radio_off)(void *ctx);
};

void powersave_init(struct powersave *ps, struct powersave_ops *ops, void *ctx);
void powersave_deinit(struct powersave *ps);

void powersave_start(struct powersave *ps);
void powersave_stop(struct powersave *ps);
bool powersave_tx(struct powersave *ps);
void powersave_rx(struct powersave *ps);
void powersave_nulldata_status(struct powersave *ps, bool ack);

/* maybe for wl12xx's BT implementation: */
void powersave_disable_dynps(struct powersave *ps);
void powersave_enable_dynps(struct powersave *ps);


I think this would be created per (managed) interface by the driver. I
don't think we need to hide the internals, and that makes it easier to
just have such a struct in the vif struct.

Additional APIs might be needed for some of the configuration
parameters, not really sure yet.

The API rules would be that the set_radio() callback is always called
within a function call, which is why timeout_radio_off() is a separate
callback (locking would be different).


I haven't really full thought this through but it doesn't seem
impossible to do. Thoughts?

johannes

