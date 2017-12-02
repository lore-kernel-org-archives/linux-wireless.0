Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:38567 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752353AbdLBWsl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 17:48:41 -0500
Subject: Re: [PATCH net 1/2] netlink: add NLA_U8_BUGGY attribute type
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
References: <20171202202332.10205-1-johannes@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <bd801ee5-2f29-1797-26a3-e3d852294d47@gmail.com> (sfid-20171202_235807_516940_5559F3FD)
Date: Sat, 2 Dec 2017 15:48:36 -0700
MIME-Version: 1.0
In-Reply-To: <20171202202332.10205-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/2/17 1:23 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> This netlink type is used only for backwards compatibility
> with broken userspace that used the wrong size for a given
> u8 attribute, which is now rejected. It would've been wrong
> before already, since on big endian the wrong value (always
> zero) would be used by the kernel, but we can't break the
> existing deployed userspace - hostapd for example now fails
> to initialize entirely.
> 
> We could try to fix up the big endian problem here, but we
> don't know *how* userspace misbehaved - if using nla_put_u32
> then we could, but we also found a debug tool (which we'll
> ignore for the purposes of this regression) that was putting
> the padding into the length.
> 
> Fixes: 28033ae4e0f5 ("net: netlink: Update attr validation to require exact length for some types")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Hi Johannes:

I have been really busy the past 2 weeks, so have not gotten around to
dealing with this. I was planning to partially revert 28033ae4e0f5 --
change it from failure to log an error message so buggy commands can be
fixed.

David
