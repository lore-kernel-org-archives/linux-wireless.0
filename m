Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17724 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYDRJFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 05:05:00 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Date: Fri, 18 Apr 2008 11:02:03 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1208448814.9212.270.camel@pmac.infradead.org>
In-Reply-To: <1208448814.9212.270.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200804181102.03107.hs4233@mail.mn-solutions.de> (sfid-20080418_100504_738768_356D5588)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NACK.

When I apply this patch and do "ethtool -S eth1", I get this:

$ ethtool -S eth1
NIC statistics:
=A0 =A0 =A0drop_duplicate_bcast: 7
=A0 =A0 =A0drop_ttl_zero: 0
=A0 =A0 =A0drop_no_fwd_route: 0
=A0 =A0 =A0drop_no_buffers: 9223372036854775808
=A0 =A0 =A0fwded_unicast_cnt: 0
=A0 =A0 =A0fwded_bcast_cnt: 0
=A0 =A0 =A0drop_blind_table: 0
=A0 =A0 =A0tx_failed_cnt: 9223372036854775808

But more severely, I get this in dmesg:

libertas enter: lbs_ethtool_get_stats()
libertas: PREP_CMD: command 0x009b failed: 2
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0
My firmware simply doesn't support the 009b command. It seems=20
also wrong to call an MESH related command on an struct=20
net_device *dev which is not priv->mesh_dev.


That ethtool returns junk like "9223372036854775808" is another=20
error. lbs_mesh_access() returned 2, and the code does "if (ret)=20
return ret". Maybe it should be like "if (ret) return -ENOSYS=20
(or some other ENOxxx) instead?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
