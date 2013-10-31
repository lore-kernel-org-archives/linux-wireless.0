Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab3JaPZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 11:25:21 -0400
Message-ID: <1383233115.14302.2.camel@jlt4.sipsolutions.net> (sfid-20131031_162524_594902_E7739A17)
Subject: Re: [PATCH] cfg80211: Introduce critical protocol indication for
 p2p connection.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Undekari, Sunil Dutt" <usdutt@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Date: Thu, 31 Oct 2013 16:25:15 +0100
In-Reply-To: <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
References: <1383230452-12608-1-git-send-email-usdutt@qti.qualcomm.com>
	 (sfid-20131031_154108_037102_6F3E1A6D) <1383230593.14302.1.camel@jlt4.sipsolutions.net>
	 <26F3B0343EE4744AA14EEEF9E1E534511F7A65CC@aphydexd01a>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-31 at 15:22 +0000, Undekari, Sunil Dutt wrote:
> > That's not what the critical protocol stuff was designed for, so no.
> I would consider the P2P connection phase (P2P+WPS+WPA) to be critical 
> and any off channel operations (scan) triggered by the host driver would result in 
> the delayed / failed P2P connection attempt.
> I suppose there should be an indication to the host driver w.r.t p2p connection 
> attempt so that any off load operations on any other interface sharing the same radio 
> would be avoided by the driver.
> Since there is already an existing interface through the critical protocol indication, I 
> thought of extending it to also include a P2P protocol/connection. This new proto id 
> would be an indication to the drivers to allow the scan on the current interface 
> and avoid any scans on another considering the fact that a p2p connection requires a  
> scan.
> Do you propose an alternative (a new interface?) to achieve the same?

Just do it in the supplicant - that has full control over what's going
on with a given device.

Trying to have the kernel manage multiple things that may or may not be
exclusive and are all done in userspace is going to be a futile
exercise.

johannes

