Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:44683 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab2DXIuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 04:50:44 -0400
Message-ID: <4F966960.20700@neratec.com> (sfid-20120424_105048_136459_8C6164BD)
Date: Tue, 24 Apr 2012 10:50:40 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Jonathan Bither <jonbither@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: New DFS pattern detector
References: <4F965B47.1080000@gmail.com>
In-Reply-To: <4F965B47.1080000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonathan,

an earlier proposal for the DFS pattern detector posted at [1] was in 
fact located in the common ath layer and meant to be used by all DFS 
capable Atheros devices.

For the sake of simplicity and based on assumptions that ath9k will be 
the first driver to use it, the detector was finally moved into ath9k. 
So far, it is independent of the underlying HW and if there was a 
consensus that it could be used by ath5k or other drivers, I'll take 
care to move it back to the ath layer.

FYI, the initial plans were even to have the detector fully abstracted 
from the underlying driver and provide it as part of mac80211. With no 
further feedback from other chip-manufacturers the generic approach was 
dropped and became Atheros specific.


Feel free to ask for further details, though I'm out of office right now 
and will respond delayed.

HTH, Zefir

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/84402

On 24.04.2012 09:50, Jonathan Bither wrote:
> Hey List,
> 	With the new DFS pattern detector that was added for ath9k, I was curious if this would be beneficial for the ath5k and possibly other drivers as well. Was there any interest in perhaps making this a common API?
>
> Thanks,
> Jonathan Bither
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

