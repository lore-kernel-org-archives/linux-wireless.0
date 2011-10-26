Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57729 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab1JZXW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 19:22:58 -0400
Received: by ggnb1 with SMTP id b1so2058490ggn.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Oct 2011 16:22:57 -0700 (PDT)
Message-ID: <4EA8965D.2030207@lwfinger.net> (sfid-20111027_012302_358517_0460C5B7)
Date: Wed, 26 Oct 2011 18:23:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Proud <setamagiga@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188RU no injection?
References: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
In-Reply-To: <CAF7qGM4BL10gn2786kW73sAk8f-y8CzX0rx2BQsY_Q96W=pfog@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030907010202070501060000"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030907010202070501060000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/2011 05:29 PM, Roman Proud wrote:
> Hi there,
>
> i hope you guys can help me.
> I wanted a new Wifi card, because mine has no injection, what i need sometimes.
>
> So i forced the Internet to find that a 8187 would be best for. So i
> bought the 8188 (newer = better?)... i never had thought about so much
> difference in just one number... it was horrible to even get the card
> work, first no monitor mode works, but now it does (i dunno why
> O_o)... The only thing i miss is Package injection.

Well, your research should have shown that the 8187 chip is an 802.11g version, 
while the 8188 works with 802.11n. That should have given you a clue that the 
driver would be VERY different.

> So my Question. Is it there? is it in the driver and i just have to do
> some magic again like i did with the monitor mode?
> If not, is there any Patch? (i didn't find anything...)
> Or should i simply send the damn thing back and get me an 8187? (its
> not that simple, and i like hacking into my linux, so one of the first
> both, would be nicer)

What kernel are you using? If you want the latest version of wireless code, you 
should be running the version found in the git repo at
git://git.infradead.org/users/linville/wireless-next.git. Your next-best option 
would be to get the bleeding-edge version of compat-wireless and build it for 
your current kernel.

There is a bug in rtlwifi that affects monitor mode in rtl8192cu, rtl8192ce, 
rtl8192se, and rtl8192de. I think it is fixed by the attached patch. At least 
monitor mode works here after the patch is applied. Please let me know if it 
works for you.

Larry




--------------030907010202070501060000
Content-Type: text/plain;
 name="rtl8192cu_monitor"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl8192cu_monitor"

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/core.c
@@ -375,6 +375,7 @@ static void rtl_op_configure_filter(stru
 					  rtlpriv->cfg->maps[MAC_RCR_AB]);
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive multicast frame.\n"));
+			*new_flags |= FIF_ALLMULTI;
 		}
 	}
 
@@ -387,6 +388,7 @@ static void rtl_op_configure_filter(stru
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACRC32];
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive FCS error frame.\n"));
+			*new_flags |= FIF_FCSFAIL;
 		}
 	}
 
@@ -400,6 +402,7 @@ static void rtl_op_configure_filter(stru
 				rtlpriv->cfg->ops->set_chk_bssid(hw, false);
 			} else {
 				rtlpriv->cfg->ops->set_chk_bssid(hw, true);
+				*new_flags |= FIF_BCN_PRBRESP_PROMISC;
 			}
 		}
 	}
@@ -414,6 +417,7 @@ static void rtl_op_configure_filter(stru
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_ACF];
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive control frame.\n"));
+			*new_flags |= FIF_CONTROL;
 		}
 	}
 
@@ -426,6 +430,7 @@ static void rtl_op_configure_filter(stru
 			mac->rx_conf &= ~rtlpriv->cfg->maps[MAC_RCR_AAP];
 			RT_TRACE(rtlpriv, COMP_MAC80211, DBG_LOUD,
 				 ("Disable receive other BSS's frame.\n"));
+			*new_flags |= FIF_OTHER_BSS;
 		}
 	}
 }

--------------030907010202070501060000--
