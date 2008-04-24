Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:39970 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbYDXJ4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 05:56:23 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: "'Dan Williams'" <dcbw@redhat.com>,
	"'Johannes Berg'" <johannes@sipsolutions.net>,
	<hostap@lists.shmoo.com>,
	"'Holger Schurig'" <hs4233@mail.mn-solutions.de>,
	<linux-wireless@vger.kernel.org>
Subject: RE: Roaming problems
Date: Thu, 24 Apr 2008 11:55:52 +0200
Message-ID: <009e01c8a5f1$625e0790$0b3ca8c0@gotws1589> (sfid-20080424_115655_774659_8DCD5E51)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200804240845.41867.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> > I'm not disputing that as a reasonable approach.  But FWIW for two 
> > years we've been saying it is OK for drivers to use setting SSID as 
> > the only trigger for association.  Is that not your understanding?
> 

Sorry, I din not know that there has been a discussion about the feature of
letting 'SSID set' trigger an association.

It's OK, but then the wpa_supplicant needs to 'cancel' current settings in
the driver before it start prepare for the new AP.
As I have understood it, that is done by issuing a BSSID of
00:00:00:00:00:00. I will look into a patch for that.

An other aspect of the selected design. If the driver (STA) is associated
with an BSSID and the wpa_supplicant would like to change BSSID, who is
responsible for a proper de- association/authentication from the first BSSID
?

My findings says that the network does not allow an STA to
associate/authenticate with one BSSID while it still have a valid aid with
an other BSSID. At least my Cisco AP does not allow that. 

/Lars

