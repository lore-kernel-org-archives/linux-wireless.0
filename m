Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:33397 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbXLNFJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 00:09:09 -0500
Date: Thu, 13 Dec 2007 21:08:08 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: clean up frame receive handling
Message-ID: <20071214050808.GE5698@jm.kir.nu> (sfid-20071214_050912_384570_418781DD)
References: <1197483844.6558.158.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197483844.6558.158.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2007 at 07:24:04PM +0100, Johannes Berg wrote:

> This cleans up the frame receive handling. After this patch
>  * EAPOL frames addressed to us or the EAPOL group address are
>    always accepted regardless of whether they are encrypted or not
>  * other frames from a station are dropped if PAE is enabled and
>    the station is not authorized

Is there any way for an user space application to figure out whether a
received EAPOL frame was encrypted? In theory, WPA/WPA2 Authenticators
(e.g., hostapd) should verify that the frame was encrypted if pairwise
keys are set (whereas IEEE 802.1X Authenticator accepts unencrypted
EAPOL frames).

Did you/someone already verify that the Linux bridge code does not
bridge EAPOL frames? The use of a separate interface for this removed
the need for doing such filtering based on ethertype, but with EAPOL
frames using the same netdev with other data frames, the bridge code
should filter these out (mainly the PAE group addressed ones, but if I
remember correctly, IEEE 802.1X specified all frames using EAPOL
ethertype not to be bridged).

I haven't looked into the current implementations and/or proposed
patches on for TX part, but I would assume that it is possible to select
whether an EAPOL frame will be encrypted when injecting it(?).

-- 
Jouni Malinen                                            PGP id EFC895FA
