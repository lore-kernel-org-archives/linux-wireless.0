Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36069 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2G0DxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 23:53:10 -0400
Received: by obbuo13 with SMTP id uo13so3674458obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 20:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207262212.06227.chunkeey@googlemail.com>
References: <1343332743-11845-1-git-send-email-jlopex@cozybit.com> <201207262212.06227.chunkeey@googlemail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 26 Jul 2012 20:52:49 -0700
Message-ID: <CAPjQAd_0sD69dunzyd4Bx9Ys_XgTA9-Zr5TJkfNweopJWNBTJQ@mail.gmail.com> (sfid-20120727_055314_937880_72F0CAD6)
Subject: Re: [PATCH] carl9170: Add support for NL80211_IFTYPE_MESH_POINT interfaces
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Javier Lopez <jlopex@cozybit.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2012 at 1:12 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday 26 July 2012 21:59:03 Javier Lopez wrote:
>> This patch contains following modifications:
>>
>> - Add mesh capabilities on fw.c to permit creation of mesh
>>   interfaces using this driver.
>>
>> - Modify carl9170_set_operating_mode, to use AP-style beaconing
>>   with mesh interfaces.
>>
>> - Allow beacon updates for NL80211_IFTYPE_MESH_POINT type in
>>   carl9170_handle_command_response.
>>
>> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
> Hm, what about virtual interfaces?
>
> Do you think it's save to share a MESH node with
> a STA, IBSS, AP interface on the same hardware?

Does this hardware support multiple beacons?
If not, we probably should limit the driver to only accept one
beaconing vif at a time (e.g. one mesh vif + multiple STAs vifs ok).

> On a side node: Can you tell me anything about
> the crypto of mesh traffic? Because currently,
> the code will disable any hardware crypto
> offload for any mode other than STA and AP.

The hardware crypto needs to support one tx/rx pairwise key per peer,
a groupwise key for each peer and management frame protection.
Not sure if this is the case for this hardware, so until we do, it
seems reasonable to disable crypto offload.

Cheers,

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
