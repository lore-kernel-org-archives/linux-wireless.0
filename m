Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34748 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbbCaUuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 16:50:12 -0400
Received: by iedfl3 with SMTP id fl3so29871420ied.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 13:50:11 -0700 (PDT)
Date: Tue, 31 Mar 2015 16:49:33 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ferran <ranker72@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Fwd: Unable to operate a rt2770 device at 5GHz in mesh mode
Message-ID: <20150331204933.GC11601@localhost> (sfid-20150331_225017_730782_CB334130)
References: <551AE9AD.4050102@gmail.com>
 <551AEB27.1020003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <551AEB27.1020003@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2015 at 08:44:55PM +0200, ferran wrote:
>   * Channels 12,13,14 and 36 to 48 and 149 to 165
> 
>     ffff MHz [cc] (20.0 dBm) (passive scanning, no IBSS)
                                ^^^^^^^^^^^^^^^^^^^^^^^^^

In other words you cannot send beacons or other frames on this
channel.

> Does
> it have anything to do with regulation restrictions? I have succeeded at
> connecting to an AP at 5 GHz in managed mode.

Yes.

Once you start a mesh, it will create the mesh and start beaconing
immediately, so the regulatory domain of your device and/or CRDA may prevent
you from doing this.

In managed mode, the device is not beaconing so it doesn't have this
limitation, although it will not be able to send probe requests.

-- 
Bob Copeland %% http://bobcopeland.com/
