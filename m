Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZK1UgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 15:36:21 -0500
Subject: Re: [PATCH] mac80211: annotate sleeping driver ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
References: <1259439566-26397-1-git-send-email-kalle.valo@iki.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vzuP5rhAfQEx+UvmVXGU"
Date: Sat, 28 Nov 2009 21:36:23 +0100
Message-ID: <1259440583.5428.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vzuP5rhAfQEx+UvmVXGU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-28 at 22:19 +0200, Kalle Valo wrote:
> To make it easier to notice cases of calling sleeping ops in atomic conte=
xt,
> annotate driver-ops.h with appropiate might_sleep() calls. At the same ti=
me,
> also document in mac80211.h the op functions with missing contexts.
>=20
> mac80211 doesn't seem to use get_tx_stats anywhere currently. Just to be =
on
> the safe side, I documented it to be atomic, but hopefully the op can be
> removed in the future.
>=20
> Compile-tested only.

Nice, thanks. Haven't reviewed it in detail, but I'll trust you :)

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
> ---
>  include/net/mac80211.h    |   41 +++++++++++++++++++++++--------
>  net/mac80211/driver-ops.h |   58 +++++++++++++++++++++++++++++++++++++++=
++---
>  2 files changed, 84 insertions(+), 15 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 2e484bc..fafc503 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1342,155 +1342,174 @@ enum ieee80211_ampdu_mlme_action {
>   *	Must be implemented and atomic.
>   *
>   * @start: Called before the first netdevice attached to the hardware
>   *	is enabled. This should turn on the hardware and must turn on
>   *	frame reception (for possibly enabled monitor interfaces.)
>   *	Returns negative error codes, these may be seen in userspace,
>   *	or zero.
>   *	When the device is started it should not have a MAC address
>   *	to avoid acknowledging frames before a non-monitor device
>   *	is added.
> - *	Must be implemented.
> + *	Must be implemented and can sleep.
>   *
>   * @stop: Called after last netdevice attached to the hardware
>   *	is disabled. This should turn off the hardware (at least
>   *	it must turn off frame reception.)
>   *	May be called right after add_interface if that rejects
>   *	an interface. If you added any work onto the mac80211 workqueue
>   *	you should ensure to cancel it on this callback.
> - *	Must be implemented.
> + *	Must be implemented and can sleep.
>   *
>   * @add_interface: Called when a netdevice attached to the hardware is
>   *	enabled. Because it is not called for monitor mode devices, @start
>   *	and @stop must be implemented.
>   *	The driver should perform any initialization it needs before
>   *	the device can be enabled. The initial configuration for the
>   *	interface is given in the conf parameter.
>   *	The callback may refuse to add an interface by returning a
>   *	negative error code (which will be seen in userspace.)
> - *	Must be implemented.
> + *	Must be implemented and can sleep.
>   *
>   * @remove_interface: Notifies a driver that an interface is going down.
>   *	The @stop callback is called after this if it is the last interface
>   *	and no monitor interfaces are present.
>   *	When all interfaces are removed, the MAC address in the hardware
>   *	must be cleared so the device no longer acknowledges packets,
>   *	the mac_addr member of the conf structure is, however, set to the
>   *	MAC address of the device going away.
> - *	Hence, this callback must be implemented.
> + *	Hence, this callback must be implemented. It can sleep.
>   *
>   * @config: Handler for configuration requests. IEEE 802.11 code calls t=
his
>   *	function to change hardware configuration, e.g., channel.
>   *	This function should never fail but returns a negative error code
> - *	if it does.
> + *	if it does. The callback can sleep.
>   *
>   * @bss_info_changed: Handler for configuration requests related to BSS
>   *	parameters that may vary during BSS's lifespan, and may affect low
>   *	level driver (e.g. assoc/disassoc status, erp parameters).
>   *	This function should not be used if no BSS has been set, unless
>   *	for association indication. The @changed parameter indicates which
> - *	of the bss parameters has changed when a call is made.
> + *	of the bss parameters has changed when a call is made. The callback
> + *	can sleep.
>   *
>   * @prepare_multicast: Prepare for multicast filter configuration.
>   *	This callback is optional, and its return value is passed
>   *	to configure_filter(). This callback must be atomic.
>   *
>   * @configure_filter: Configure the device's RX filter.
>   *	See the section "Frame filtering" for more information.
> - *	This callback must be implemented.
> + *	This callback must be implemented and can sleep.
>   *
>   * @set_tim: Set TIM bit. mac80211 calls this function when a TIM bit
>   * 	must be set or cleared for a given STA. Must be atomic.
>   *
>   * @set_key: See the section "Hardware crypto acceleration"
> - *	This callback can sleep, and is only called between add_interface
> - *	and remove_interface calls, i.e. while the given virtual interface
> + *	This callback is only called between add_interface and
> + *	remove_interface calls, i.e. while the given virtual interface
>   *	is enabled.
>   *	Returns a negative error code if the key can't be added.
> + *	The callback can sleep.
>   *
>   * @update_tkip_key: See the section "Hardware crypto acceleration"
>   * 	This callback will be called in the context of Rx. Called for driver=
s
>   * 	which set IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY.
> + *	The callback can sleep.
>   *
>   * @hw_scan: Ask the hardware to service the scan request, no need to st=
art
>   *	the scan state machine in stack. The scan must honour the channel
>   *	configuration done by the regulatory agent in the wiphy's
>   *	registered bands. The hardware (or the driver) needs to make sure
>   *	that power save is disabled.
>   *	The @req ie/ie_len members are rewritten by mac80211 to contain the
>   *	entire IEs after the SSID, so that drivers need not look at these
>   *	at all but just send them after the SSID -- mac80211 includes the
>   *	(extended) supported rates and HT information (where applicable).
>   *	When the scan finishes, ieee80211_scan_completed() must be called;
>   *	note that it also must be called when the scan cannot finish due to
>   *	any error unless this callback returned a negative error code.
> + *	The callback can sleep.
>   *
>   * @sw_scan_start: Notifier function that is called just before a softwa=
re scan
>   *	is started. Can be NULL, if the driver doesn't need this notification=
.
> + *	The callback can sleep.
>   *
> - * @sw_scan_complete: Notifier function that is called just after a soft=
ware scan
> - *	finished. Can be NULL, if the driver doesn't need this notification.
> + * @sw_scan_complete: Notifier function that is called just after a
> + *	software scan finished. Can be NULL, if the driver doesn't need
> + *	this notification.
> + *	The callback can sleep.
>   *
>   * @get_stats: Return low-level statistics.
>   * 	Returns zero if statistics are available.
> + *	The callback can sleep.
>   *
>   * @get_tkip_seq: If your device implements TKIP encryption in hardware =
this
>   *	callback should be provided to read the TKIP transmit IVs (both IV32
>   *	and IV16) for the given key from hardware.
> + *	The callback must be atomic.
>   *
>   * @set_rts_threshold: Configuration of RTS threshold (if device needs i=
t)
> + *	The callback can sleep.
>   *
>   * @sta_notify: Notifies low level driver about addition, removal or pow=
er
>   *	state transition of an associated station, AP,  IBSS/WDS/mesh peer et=
c.
>   *	Must be atomic.
>   *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
>   *	bursting) for a hardware TX queue.
>   *	Returns a negative error code on failure.
> + *	The callback can sleep.
>   *
>   * @get_tx_stats: Get statistics of the current TX queue status. This is=
 used
>   *	to get number of currently queued packets (queue length), maximum que=
ue
>   *	size (limit), and total number of packets sent using each TX queue
>   *	(count). The 'stats' pointer points to an array that has hw->queues
>   *	items.
> + *	The callback must be atomic.
>   *
>   * @get_tsf: Get the current TSF timer value from firmware/hardware. Cur=
rently,
>   *	this is only used for IBSS mode BSSID merging and debugging. Is not a
>   *	required function.
> + *	The callback can sleep.
>   *
>   * @set_tsf: Set the TSF timer to the specified value in the firmware/ha=
rdware.
>   *      Currently, this is only used for IBSS mode debugging. Is not a
>   *	required function.
> + *	The callback can sleep.
>   *
>   * @reset_tsf: Reset the TSF timer and allow firmware/hardware to synchr=
onize
>   *	with other STAs in the IBSS. This is only used in IBSS mode. This
>   *	function is optional if the firmware/hardware takes full care of
>   *	TSF synchronization.
> + *	The callback can sleep.
>   *
>   * @tx_last_beacon: Determine whether the last IBSS beacon was sent by u=
s.
>   *	This is needed only for IBSS mode and the result of this function is
>   *	used to determine whether to reply to Probe Requests.
>   *	Returns non-zero if this device sent the last beacon.
> + *	The callback can sleep.
>   *
>   * @ampdu_action: Perform a certain A-MPDU action
>   * 	The RA/TID combination determines the destination and TID we want
>   * 	the ampdu action to be performed for. The action is defined through
>   * 	ieee80211_ampdu_mlme_action. Starting sequence number (@ssn)
>   * 	is the first frame we expect to perform the action on. Notice
>   * 	that TX/RX_STOP can pass NULL for this parameter.
>   *	Returns a negative error code on failure.
> + *	The callback must be atomic.
>   *
>   * @rfkill_poll: Poll rfkill hardware state. If you need this, you also
>   *	need to set wiphy->rfkill_poll to %true before registration,
>   *	and need to call wiphy_rfkill_set_hw_state() in the callback.
> + *	The callback can sleep.
>   *
>   * @testmode_cmd: Implement a cfg80211 test mode command.
> + *	The callback can sleep.
>   */
>  struct ieee80211_ops {
>  	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
>  	int (*start)(struct ieee80211_hw *hw);
>  	void (*stop)(struct ieee80211_hw *hw);
>  	int (*add_interface)(struct ieee80211_hw *hw,
>  			     struct ieee80211_if_init_conf *conf);
>  	void (*remove_interface)(struct ieee80211_hw *hw,
>  				 struct ieee80211_if_init_conf *conf);
>  	int (*config)(struct ieee80211_hw *hw, u32 changed);
> diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
> index 921dd9c..0fdca07 100644
> --- a/net/mac80211/driver-ops.h
> +++ b/net/mac80211/driver-ops.h
> @@ -7,68 +7,84 @@
> =20
>  static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *=
skb)
>  {
>  	return local->ops->tx(&local->hw, skb);
>  }
> =20
>  static inline int drv_start(struct ieee80211_local *local)
>  {
>  	int ret;
> =20
> +	might_sleep();
> +
>  	local->started =3D true;
>  	smp_mb();
>  	ret =3D local->ops->start(&local->hw);
>  	trace_drv_start(local, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_stop(struct ieee80211_local *local)
>  {
> +	might_sleep();
> +
>  	local->ops->stop(&local->hw);
>  	trace_drv_stop(local);
> =20
>  	/* sync away all work on the tasklet before clearing started */
>  	tasklet_disable(&local->tasklet);
>  	tasklet_enable(&local->tasklet);
> =20
>  	barrier();
> =20
>  	local->started =3D false;
>  }
> =20
>  static inline int drv_add_interface(struct ieee80211_local *local,
>  				    struct ieee80211_if_init_conf *conf)
>  {
> -	int ret =3D local->ops->add_interface(&local->hw, conf);
> +	int ret;
> +
> +	might_sleep();
> +
> +	ret =3D local->ops->add_interface(&local->hw, conf);
>  	trace_drv_add_interface(local, conf->mac_addr, conf->vif, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_remove_interface(struct ieee80211_local *local,
>  					struct ieee80211_if_init_conf *conf)
>  {
> +	might_sleep();
> +
>  	local->ops->remove_interface(&local->hw, conf);
>  	trace_drv_remove_interface(local, conf->mac_addr, conf->vif);
>  }
> =20
>  static inline int drv_config(struct ieee80211_local *local, u32 changed)
>  {
> -	int ret =3D local->ops->config(&local->hw, changed);
> +	int ret;
> +
> +	might_sleep();
> +
> +	ret =3D local->ops->config(&local->hw, changed);
>  	trace_drv_config(local, changed, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_bss_info_changed(struct ieee80211_local *local,
>  					struct ieee80211_vif *vif,
>  					struct ieee80211_bss_conf *info,
>  					u32 changed)
>  {
> +	might_sleep();
> +
>  	if (local->ops->bss_info_changed)
>  		local->ops->bss_info_changed(&local->hw, vif, info, changed);
>  	trace_drv_bss_info_changed(local, vif, info, changed);
>  }
> =20
>  static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
>  					int mc_count,
>  					struct dev_addr_list *mc_list)
>  {
>  	u64 ret =3D 0;
> @@ -103,142 +119,174 @@ static inline int drv_set_tim(struct ieee80211_lo=
cal *local,
>  		ret =3D local->ops->set_tim(&local->hw, sta, set);
>  	trace_drv_set_tim(local, sta, set, ret);
>  	return ret;
>  }
> =20
>  static inline int drv_set_key(struct ieee80211_local *local,
>  			      enum set_key_cmd cmd, struct ieee80211_vif *vif,
>  			      struct ieee80211_sta *sta,
>  			      struct ieee80211_key_conf *key)
>  {
> -	int ret =3D local->ops->set_key(&local->hw, cmd, vif, sta, key);
> +	int ret;
> +
> +	might_sleep();
> +
> +	ret =3D local->ops->set_key(&local->hw, cmd, vif, sta, key);
>  	trace_drv_set_key(local, cmd, vif, sta, key, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_update_tkip_key(struct ieee80211_local *local,
>  				       struct ieee80211_key_conf *conf,
>  				       const u8 *address, u32 iv32,
>  				       u16 *phase1key)
>  {
> +	might_sleep();
> +
>  	if (local->ops->update_tkip_key)
>  		local->ops->update_tkip_key(&local->hw, conf, address,
>  					    iv32, phase1key);
>  	trace_drv_update_tkip_key(local, conf, address, iv32);
>  }
> =20
>  static inline int drv_hw_scan(struct ieee80211_local *local,
>  			      struct cfg80211_scan_request *req)
>  {
> -	int ret =3D local->ops->hw_scan(&local->hw, req);
> +	int ret;
> +
> +	might_sleep();
> +
> +	ret =3D local->ops->hw_scan(&local->hw, req);
>  	trace_drv_hw_scan(local, req, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_sw_scan_start(struct ieee80211_local *local)
>  {
> +	might_sleep();
> +
>  	if (local->ops->sw_scan_start)
>  		local->ops->sw_scan_start(&local->hw);
>  	trace_drv_sw_scan_start(local);
>  }
> =20
>  static inline void drv_sw_scan_complete(struct ieee80211_local *local)
>  {
> +	might_sleep();
> +
>  	if (local->ops->sw_scan_complete)
>  		local->ops->sw_scan_complete(&local->hw);
>  	trace_drv_sw_scan_complete(local);
>  }
> =20
>  static inline int drv_get_stats(struct ieee80211_local *local,
>  				struct ieee80211_low_level_stats *stats)
>  {
>  	int ret =3D -EOPNOTSUPP;
> =20
> +	might_sleep();
> +
>  	if (local->ops->get_stats)
>  		ret =3D local->ops->get_stats(&local->hw, stats);
>  	trace_drv_get_stats(local, stats, ret);
> =20
>  	return ret;
>  }
> =20
>  static inline void drv_get_tkip_seq(struct ieee80211_local *local,
>  				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
>  {
>  	if (local->ops->get_tkip_seq)
>  		local->ops->get_tkip_seq(&local->hw, hw_key_idx, iv32, iv16);
>  	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
>  }
> =20
>  static inline int drv_set_rts_threshold(struct ieee80211_local *local,
>  					u32 value)
>  {
>  	int ret =3D 0;
> +
> +	might_sleep();
> +
>  	if (local->ops->set_rts_threshold)
>  		ret =3D local->ops->set_rts_threshold(&local->hw, value);
>  	trace_drv_set_rts_threshold(local, value, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_sta_notify(struct ieee80211_local *local,
>  				  struct ieee80211_vif *vif,
>  				  enum sta_notify_cmd cmd,
>  				  struct ieee80211_sta *sta)
>  {
>  	if (local->ops->sta_notify)
>  		local->ops->sta_notify(&local->hw, vif, cmd, sta);
>  	trace_drv_sta_notify(local, vif, cmd, sta);
>  }
> =20
>  static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
>  			      const struct ieee80211_tx_queue_params *params)
>  {
>  	int ret =3D -EOPNOTSUPP;
> +
> +	might_sleep();
> +
>  	if (local->ops->conf_tx)
>  		ret =3D local->ops->conf_tx(&local->hw, queue, params);
>  	trace_drv_conf_tx(local, queue, params, ret);
>  	return ret;
>  }
> =20
>  static inline int drv_get_tx_stats(struct ieee80211_local *local,
>  				   struct ieee80211_tx_queue_stats *stats)
>  {
>  	int ret =3D local->ops->get_tx_stats(&local->hw, stats);
>  	trace_drv_get_tx_stats(local, stats, ret);
>  	return ret;
>  }
> =20
>  static inline u64 drv_get_tsf(struct ieee80211_local *local)
>  {
>  	u64 ret =3D -1ULL;
> +
> +	might_sleep();
> +
>  	if (local->ops->get_tsf)
>  		ret =3D local->ops->get_tsf(&local->hw);
>  	trace_drv_get_tsf(local, ret);
>  	return ret;
>  }
> =20
>  static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
>  {
> +	might_sleep();
> +
>  	if (local->ops->set_tsf)
>  		local->ops->set_tsf(&local->hw, tsf);
>  	trace_drv_set_tsf(local, tsf);
>  }
> =20
>  static inline void drv_reset_tsf(struct ieee80211_local *local)
>  {
> +	might_sleep();
> +
>  	if (local->ops->reset_tsf)
>  		local->ops->reset_tsf(&local->hw);
>  	trace_drv_reset_tsf(local);
>  }
> =20
>  static inline int drv_tx_last_beacon(struct ieee80211_local *local)
>  {
>  	int ret =3D 1;
> +
> +	might_sleep();
> +
>  	if (local->ops->tx_last_beacon)
>  		ret =3D local->ops->tx_last_beacon(&local->hw);
>  	trace_drv_tx_last_beacon(local, ret);
>  	return ret;
>  }
> =20
>  static inline int drv_ampdu_action(struct ieee80211_local *local,
>  				   struct ieee80211_vif *vif,
>  				   enum ieee80211_ampdu_mlme_action action,
>  				   struct ieee80211_sta *sta, u16 tid,
> @@ -248,14 +296,16 @@ static inline int drv_ampdu_action(struct ieee80211=
_local *local,
>  	if (local->ops->ampdu_action)
>  		ret =3D local->ops->ampdu_action(&local->hw, vif, action,
>  					       sta, tid, ssn);
>  	trace_drv_ampdu_action(local, vif, action, sta, tid, ssn, ret);
>  	return ret;
>  }
> =20
>=20
>  static inline void drv_rfkill_poll(struct ieee80211_local *local)
>  {
> +	might_sleep();
> +
>  	if (local->ops->rfkill_poll)
>  		local->ops->rfkill_poll(&local->hw);
>  }
>  #endif /* __MAC80211_DRIVER_OPS */


--=-vzuP5rhAfQEx+UvmVXGU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLEYnDAAoJEODzc/N7+Qma9hIP/0U3OGOnsBTXBCNONoaqoLIn
mlZGSatbU8LNDdhi1bqkVc0ZPxb202PXsexlB/MVUvCHICKf7AP3wckodYhezqA5
iuXVR6m9cy5mrV/6dSqvWRVNNugDGaFB8HwkXsk7lcHPIWfeOUVCIouNPbdeoE0E
Apxl1P9B6rVu6Ikg9VI0Gnskqo3FwLPi32AMXsG2/Irvqr8//1MIam2kzDLXV0fG
m1rNiiA1DZcTOC6gMU3e3/4O9bCihTQY1pHYqBm18NqClrX0buRGvPjb9Nr2tfJ8
BBHtC9mB8IPAS7idE7/3LvLcZnUs5XmgiU7ix76P4RH+rfaHIkUnsRpP72Qu6mZB
wiJ1fAVmJOXcGb/7f4e0MfkvnXQ+o9fXMG3l8fER0U++bczwvHKsryMVCkLXBsvX
u/5VoNzkZEZXJweBFhuPHp3EPVG2CL0Kj2M3ZrD4eVxI+rWlcbbup4HEaxZP/DCd
dOKSqbKAkwJOggBdUOPXtL3Q75W1OkarqTxWUlBY8h3Xpx+VMpNFQIl8wuxSBd1F
x/Ceycj3AViFI6RZnd2lsh9i1UmaQEfKkC1h+Pq0EZEThUx9511u2+ImEtGBdEfK
H0vnjlqmrXegIm4LH1k76hgcsweyvT7bniFWElxtvyAQdP5r2NybzMLQo1oFYLEy
aGK4Z5gVGCK9t5wCBCL1
=tF30
-----END PGP SIGNATURE-----

--=-vzuP5rhAfQEx+UvmVXGU--

