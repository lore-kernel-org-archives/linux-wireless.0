Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55790 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab1B1SuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 13:50:21 -0500
Received: by vws12 with SMTP id 12so3380724vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Feb 2011 10:50:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110227104723.GA8482@jm.kir.nu>
References: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
 <1298683960-20835-3-git-send-email-thomas@cozybit.com> <20110227104723.GA8482@jm.kir.nu>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 28 Feb 2011 10:44:32 -0800
Message-ID: <AANLkTimJDFcJLar6j_gtb=k8qQSN9AJVLLuCGqnqzcAK@mail.gmail.com>
Subject: Re: [PATCH 2/5] mac80211: Let user space receive and send mesh
 auth/deauth frames
To: Jouni Malinen <j@w1.fi>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Sun, Feb 27, 2011 at 2:47 AM, Jouni Malinen <j@w1.fi> wrote:
> On Fri, Feb 25, 2011 at 05:32:37PM -0800, Thomas Pedersen wrote:
>> From: Javier Cardona <javier@cozybit.com>
>> @@ -529,7 +529,9 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
>>       [NL80211_IFTYPE_MESH_POINT] = {
>> +             .rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
>> +                     BIT(IEEE80211_STYPE_AUTH >> 4) |
>> +                     BIT(IEEE80211_STYPE_DEAUTH >> 4),
>
> This seems to be pointing towards processing the full Authentication
> frame in user space. However, some other patches in this series seemed
> to be extending the NL80211_CMD_AUTHENTICATE mechanism to allow SAE to
> be implemented on top of it. Which direction is being taken here? Or are
> both mechanisms going to be used depending on iftype?

The patches were sent to the list before proper review.  The changes
to NL80211_CMD_AUTHENTICATE were left over from an earlier
implementation variant and will be removed in the final submission.

> For non-mesh cases, I would probably prefer NL80211_CMD_AUTHENTICATE
> extension for the station vif to continue with the style we started for
> FT. The AP vif is already handling the full Authentication frame in user
> space, so that is fine to for SAE, too.

Ah, thanks for the suggestion.  As I mentioned on a previous e-mail,
our current goal is to implement SAE for mesh interfaces.  But will
definitely follow your advice if we ever attempt to implement station
mode support.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
