Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plexity.net ([206.123.115.38]:40577 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0BIUeP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 15:34:15 -0500
Date: Tue, 9 Feb 2010 12:24:21 -0800
From: Deepak Saxena <dsaxena@plexity.net>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [BUG?] ieee80211_ops.remove_interface() being called twice
Message-ID: <20100209202421.GA31240@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm working on getting the libertas_tf driver on 2.6.31 working on an
XO-1 laptopt with a USB connected device and running into the following
situation during a suspend:

Upon initiating a suspend, lbtf_op_remove_interface() gets called via
the wiphy_suspend() path:

[  142.576332]  [<cf946376>] lbtf_op_remove_interface+0x17/0x7c [libertas_tf]   
[  142.583333]  [<c06c260f>] __ieee80211_suspend+0x1c3/0x200                    
[  142.588776]  [<c06bb9d6>] ieee80211_suspend+0x15/0x17                        
[  142.593953]  [<c06a3807>] wiphy_suspend+0x38/0x48                            
[  142.598695]  [<c0432371>] ? down+0x2b/0x2f                                   
[  142.602932]  [<c05b693a>] dpm_suspend_start+0x214/0x32a                      
[  142.608203]  [<c04403a1>] suspend_devices_and_enter+0x38/0x165               
[  142.614153]  [<c0440596>] enter_state+0xc8/0x114                             
[  142.618800]  [<c043fde4>] state_store+0x98/0xad                              
[  142.623460]  [<c043fd4c>] ? state_store+0x0/0xad                             
[  142.628111]  [<c056abd1>] kobj_attr_store+0x16/0x22                          
[  142.633105]  [<c04c22d7>] sysfs_write_file+0xc0/0xeb                         
[  142.638107]  [<c0485432>] vfs_write+0x8a/0x117                               
[  142.642683]  [<c04c2217>] ? sysfs_write_file+0x0/0xeb                        
[  142.647771]  [<c0485556>] sys_write+0x3b/0x60                                
[  142.652397]  [<c04033d4>] sysenter_do_call+0x12/0x26    

Later on, the USB device is removed from the tree and 
lbtf_op_remove_interface() gets called again and this causes
an OOOPS:

[  143.209556]  [<cf946376>] lbtf_op_remove_interface+0x17/0x7c
[libertas_tf]   
[  143.216547]  [<c06b8a50>] ieee80211_stop+0x373/0x3db                         
[  143.221547]  [<c06cb2b6>] ? _spin_unlock_bh+0x1a/0x1c                        
[  143.226736]  [<c0626627>] dev_close+0x6c/0x88                                
[  143.231128]  [<c06266bb>] rollback_registered+0x78/0x204                     
[  143.236560]  [<c0626879>] unregister_netdevice+0x32/0x4d                     
[  143.241901]  [<c06b832c>] ieee80211_remove_interfaces+0x68/0x77              
[  143.247942]  [<c06ae5fa>] ieee80211_unregister_hw+0x38/0xc3                  
[  143.253564]  [<cf9461a5>] lbtf_remove_card+0x31/0x3e [libertas_tf]           
[  143.259891]  [<cf981966>] if_usb_disconnect+0x20/0x3e [libertas_tf_usb]      
[  143.266701]  [<ce758b32>] usb_unbind_interface+0x4b/0xbe [usbcore]           
[  143.272999]  [<c05b3ddf>] __device_release_driver+0x47/0x7f                  
[  143.278601]  [<c05b3eb4>] device_release_driver+0x18/0x23                    
[  143.284236]  [<ce758cf2>] usb_driver_release_interface+0x33/0x59 [usbcore]   
[  143.291347]  [<ce758d83>] usb_forced_unbind_intf+0x13/0x1a [usbcore]         
[  143.297827]  [<ce758dca>] do_unbind_rebind+0x40/0x5b [usbcore]               
[  143.303890]  [<ce758e72>] usb_external_suspend_device+0x11/0x3e [usbcore]    
[  143.310908]  [<ce758ed2>] usb_suspend+0x33/0x35 [usbcore]                    
[  143.316427]  [<ce7500fb>] usb_dev_suspend+0xd/0xf [usbcore]                  
[  143.322130]  [<c05b658a>] pm_op+0x21/0x5b                                    
[  143.326173]  [<c05b6960>] dpm_suspend_start+0x23a/0x32a                      
[  143.331534]  [<c04403a1>] suspend_devices_and_enter+0x38/0x165               
[  143.337403]  [<c0440596>] enter_state+0xc8/0x114                             
[  143.342148]  [<c043fde4>] state_store+0x98/0xad                              
[  143.346710]  [<c043fd4c>] ? state_store+0x0/0xad                             
[  143.351455]  [<c056abd1>] kobj_attr_store+0x16/0x22                          
[  143.356365]  [<c04c22d7>] sysfs_write_file+0xc0/0xeb                         
[  143.361467]  [<c0485432>] vfs_write+0x8a/0x117                               
[  143.365938]  [<c04c2217>] ? sysfs_write_file+0x0/0xeb                        
[  143.371107]  [<c0485556>] sys_write+0x3b/0x60                                
[  143.375498]  [<c04033d4>] sysenter_do_call+0x12/0x26

Following is the code for lbtf_op_remove_interface().  Basically we set 
priv->vif to NULL the first time around and then we crash on trying 
to access priv->vif->type the second time around. Easy "fix" is a NULL 
check in lbtf_op_remove_interface() to simply return to caller 
if !priv->vif, but I don't think the remove_interface() function
should be called twice. 

static void lbtf_op_remove_interface(struct ieee80211_hw *hw,
                        struct ieee80211_if_init_conf *conf)
{
        struct lbtf_private *priv = hw->priv;

        if (priv->vif->type == NL80211_IFTYPE_AP ||
            priv->vif->type == NL80211_IFTYPE_MESH_POINT)
                lbtf_beacon_ctrl(priv, 0, 0);
        lbtf_set_mode(priv, LBTF_PASSIVE_MODE);
        lbtf_set_bssid(priv, 0, NULL);
        priv->vif = NULL;
}

~Deepak

