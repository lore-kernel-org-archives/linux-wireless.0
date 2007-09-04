Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXIDQdh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 12:33:37 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <1188875058.13078.428.camel@debian.sh.intel.com>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QkoFqHvTjNNKlTBLU0I9"
Date: Tue, 04 Sep 2007 18:34:51 +0200
Message-Id: <1188923691.9942.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QkoFqHvTjNNKlTBLU0I9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Some more things.

+	case IEEE80211_FTYPE_DATA:
+		if (unlikely(is_duplicate_packet(priv, header)))
+			IWL_DEBUG_DROP("Dropping (dup): " MAC_FMT ", "
+				       MAC_FMT ", " MAC_FMT "\n",
+				       MAC_ARG(header->addr1),
+				       MAC_ARG(header->addr2),
+				       MAC_ARG(header->addr3));

mac80211 does duplicate detection.

+	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
+		if (iwl_param_hwcrypto)
+			iwl_set_decrypted_flag(priv, rxb->skb,
+					       ampdu_status, stats);
+		iwl_handle_data_packet_monitor(priv, rxb, hdr, len, stats, 0);
+		return;
+	}

why handle monitor mode differently? mac80211 does all that for you.


How much does the hardware do when you're in AP mode and have stations
in PS mode? You seem to do some things but it's not clear why.


+	/* FIXME: not sure why this doesn't work in AP mode */
+	if (priv->iw_mode !=3D IEEE80211_IF_TYPE_AP)
+		iwl_sequence_reset(priv);

Now, I'd understand that in a reverse engineered driver....

+static int iwl_mac_stop(struct ieee80211_hw *hw)
+{
+	struct iwl_priv *priv =3D hw->priv;
+
+	IWL_DEBUG_MAC80211("enter\n");
+	priv->is_open =3D 0;
+	/*netif_stop_queue(dev); */

eh? dead code in comments isn't nice especially if it's wrong.

+	if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
+		IWL_DEBUG_MAC80211("leave - monitor\n");
+		return -1;
+	}

Andy will hate you for that. And I see no point.

+	if (priv->interface_id) {
+		IWL_DEBUG_MAC80211("leave - interface_id !=3D 0\n");
+		return 0;
+	}

I don't think you should return 0 for an error case, when userspace
tries to add multiple you just accept them?

+ * We ignore conf->flags & IEEE80211_CONF_SHORT_SLOT_TIME since it seems t=
o
+ * be set inappropriately and the driver currently sets the hardware up to
+ * use it whenever needed.

would be nice to figure out if there is a bug and then fix it. I haven't
noticed one.

+	/* TODO: Figure out how to get ieee80211_local->sta_scanning w/ only
+	 * what is exposed through include/ declrations */
+	if (unlikely(!iwl_param_disable_hw_scan &&
+		     test_bit(STATUS_SCANNING, &priv->status))) {
+		IWL_DEBUG_MAC80211("leave - scanning\n");
+		mutex_unlock(&priv->mutex);
+		return 0;
+	}

Uh huh? Is that more workarounds for the hardware scanning?

+		iwl_set_rxon_hwcrypto(priv, 1);
+		iwl_commit_rxon(priv);
+		key->flags &=3D ~IEEE80211_KEY_FORCE_SW_ENCRYPT;
+		key->hw_key_idx =3D sta_id;
+		IWL_DEBUG_MAC80211("set_key success, using hwcrypto\n");

Since you're not going to be able to push the driver into .23 and .24
will include mac80211 updates, how about making it compile with those
updates? Hint: take patches from wireless-dev.

+ * The following adds a new attribute to the sysfs representation
+ * of this device driver (i.e. a new file in /sys/bus/pci/drivers/ipw/)
+ * used for controlling the debug level.
+ *
+ * See the level definitions in ipw for details.

That interface should likely live in debugfs.

+static ssize_t show_rf_kill(struct device *d,
+			    struct device_attribute *attr, char *buf)
+{
+	/*
+	 * 0 - RF kill not enabled
+	 * 1 - SW based RF kill active (sysfs)
+	 * 2 - HW based RF kill active
+	 * 3 - Both HW and SW based RF kill active

that as well, along with all the other sysfs bits. Also, how about using
the generic rfkill infrastructure Ivo did?

+	/* The following it a temporary work around due to the
+	 * suspend / resume not fully initializing the NIC correctly.

"temporary" until when?

+		if (unlikely(!network_packet))
+			IWL_DEBUG_DROP("Dropping (non network): "
+				       MAC_FMT ", " MAC_FMT ", "
+				       MAC_FMT "\n",
+				       MAC_ARG(header->addr1),
+				       MAC_ARG(header->addr2),
+				       MAC_ARG(header->addr3));

Andy will hate that as well. I wonder if his stuff actually works?

Uh. Enough for now.

johannes

--=-QkoFqHvTjNNKlTBLU0I9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3Ykr/ETPhpq3jKURAryWAJoDXotVj35MAB7pyae35yEHnDGCdwCeOKFb
crrvHRPczrbwb22yPKnAQ0M=
=WR0R
-----END PGP SIGNATURE-----

--=-QkoFqHvTjNNKlTBLU0I9--

