Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:60424 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbYIKWfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 18:35:31 -0400
Received: by rv-out-0506.google.com with SMTP id k40so526457rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 15:35:31 -0700 (PDT)
Message-ID: <45e8e6c40809111535k153af71fga6e80e43aef6cbef@mail.gmail.com> (sfid-20080912_003536_308521_8D65A580)
Date: Thu, 11 Sep 2008 15:35:30 -0700
From: "Andrey Yurovsky" <andrey@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [RFC PATCH] libertas_tf: clear current command on remove
Cc: "Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220906082.1618.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220906082.1618.22.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan.  With this patch, I get a NULL pointer dereference if I pull
the card while scanning:

6>[  131.596162] libertastf: URB in failure status: -71
<6>[  131.712016] usb 4-5: USB disconnect, address 5
<7>[  131.933390] libertastf: command 0x001d failed: -2
<1>[  131.933429] BUG: unable to handle kernel NULL pointer
dereference at 00000000
<1>[  131.933437] IP: [<f8d71d7e>]
:libertas_tf:__lbtf_cleanup_and_insert_cmd+0x2e/0x60
<4>[  131.933452] *pde = 00000000
<0>[  131.933511] Oops: 0002 [#1] SMP
<4>[  131.933519] Modules linked in: arc4 ecb crypto_blkcipher
libertas_tf_usb libertas_tf mac80211 cfg80211 binfmt_misc radeon drm
rfcomm l2cap bluetooth nfsd auth_rpcgss exportfs speedstep_lib
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative video output rfkill input_polldev sbs
sbshc battery nfs lockd nfs_acl sunrpc iptable_filter ip_tables
x_tables ac ppdev psmouse serio_raw yenta_socket rsrc_nonstatic
container parport_pc parport pcspkr iTCO_wdt iTCO_vendor_support
button intel_agp agpgart shpchp pci_hotplug ipv6 evdev ext3 jbd
mbcache usbhid hid sg sr_mod sd_mod cdrom ata_piix pata_acpi b44
floppy ata_generic libata scsi_mod dock ssb pcmcia pcmcia_core mii
ehci_hcd uhci_hcd usbcore thermal processor fan thermal_sys fuse
<4>[  131.934926]
<4>[  131.934931] Pid: 6090, comm: usb Not tainted (2.6.27-rc6-wl #1)
<4>[  131.934963] EIP: 0060:[<f8d71d7e>] EFLAGS: 00010046 CPU: 0
<4>[  131.934999] EIP is at __lbtf_cleanup_and_insert_cmd+0x2e/0x60
[libertas_tf]
<4>[  131.935032] EAX: 00000000 EBX: f4f372f0 ECX: 00000200 EDX: f4f372f0
<4>[  131.935037] ESI: f751ee60 EDI: 00000000 EBP: f751ee60 ESP: f40efecc
<4>[  131.935069]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
<0>[  131.935101] Process usb (pid: 6090, ti=f40ee000 task=f7530fc0
task.ti=f40ee000)
<0>[  131.935106] Stack: f751f7d4 fffffffe 00000282 f8d72133 f8d72e88
0000001d fffffffe 0000001d
<0>[  131.935177]        f4f372f0 00000000 f7530fc0 c013c580 f40efefc
f40efefc f751e1a0 f751fb48
<0>[  131.935275]        f751f938 f4110480 f8d7225a 00000030 f8d725d0
f40eff24 00300001 c0102c05
<0>[  131.935478] Call Trace:
<0>[  131.935509]  [<f8d72133>] __lbtf_cmd+0xd3/0x130 [libertas_tf]
<0>[  131.935551]  [<c013c580>] autoremove_wake_function+0x0/0x40
<0>[  131.935589]  [<f8d7225a>] lbtf_set_channel+0x3a/0x40 [libertas_tf]
<0>[  131.935600]  [<f8d725d0>] lbtf_cmd_copyback+0x0/0x50 [libertas_tf]
<0>[  131.935637]  [<c0102c05>] __switch_to+0xa5/x160
<0>[  131.935644]  [<c0123e8f>] finish_task_switch+0x1f/0xb0
<0>[  131.935652]  [<c0324e6b>] schedule+0x25b/0x6a0
<0>[  131.935660]  [<f8d7176>] lbtf_op_config+0x26/0x0 [libertas_tf]
<0>[  11.935750]  [<f8d91056> ieee80211_hw_config+056/0x70 [mac80211]
<0[  131.935803]  [<f8d9e49>] ieee80211_sta_scn_work+0x179/0x1e0 [ma80211]
<0>[  131.93585]  [<c01397b4>] queue_elayed_work_on+0x84/0x0
<0>[  131.935887]  [c013909a>] run_workquee+0xca/0x170
<0>[  131935949]  [<c0326ae1>]_spin_lock_irqsave+0x3/0x50
<0>[  131.936036] [<f8d97cd0>] ieee8021_sta_scan_work+0x0/0xe0 [mac80211]
<0>[  13.936085]  [<c0139980>]worker_thread+0x0/0xe0
0>[  131.936119]  [<c139a00>] worker_thread+x80/0xe0
<0>[  131.93679]  [<c013c580>] autoemove_wake_function+0x/0x40
<0>[  131.936239  [<c0139980>] workerthread+0x0/0xe0
<0>[  31.936299]  [<c013c262] kthread+0x42/0x70
<0013c20>] kthread+0x0/0x70
<0[  131.936392]  [<c0100d7>] kernel_thread_heper+0x7/0x10
<0>[  131936453]  ======================
<0>[  131.93509] Code: 85 d2 89 1c24 89 d3 89 74 24 04 8 c6 89 7c 24
08 74 33 c 42 0c 00 00 00 00 31 0 b9 00 02 00 00 c7 4210 00 00 00 00
8b 7a 1 <f3> ab 8b 96 68 09 0 00 8d 86 64 09 00 00 9 9e 68 09 00 00 89
<>[  131.937384] EIP: [f8d71d7e>]
__lbtf_clenup_and_insert_cmd+0x2/0x60 [libertas_tf] SSESP
0068:f40efecc
<4>[ 131.937384] ---[ endtrace 32fe8679f56e2101]---


On Mon, Sep 8, 2008 at 1:34 PM, Dan Williams <dcbw@redhat.com> wrote:
> Ensure that the current command is torn down when cleaning up.
>
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> ---
>
> Completely untested but based on the libertas patch for the same
> problem.  Luis, can you give it a shot and make sure there aren't any
> regressions when pulling the card or rmmod-ing the driver?
>
> diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
> index c948021..5f7bf04 100644
> --- a/drivers/net/wireless/libertas_tf/main.c
> +++ b/drivers/net/wireless/libertas_tf/main.c
> @@ -296,8 +296,8 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
>        struct lbtf_private *priv = hw->priv;
>        unsigned long flags;
>        struct sk_buff *skb;
> -
>        struct cmd_ctrl_node *cmdnode;
> +
>        /* Flush pending command nodes */
>        spin_lock_irqsave(&priv->driver_lock, flags);
>        list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
> @@ -306,7 +306,14 @@ static void lbtf_op_stop(struct ieee80211_hw *hw)
>                wake_up_interruptible(&cmdnode->cmdwait_q);
>        }
>
> +       /* Flush the command the card is currently processing */
> +       if (priv->cur_cmd) {
> +               priv->cur_cmd->result = -ENOENT;
> +               priv->cur_cmd->cmdwaitqwoken = 1;
> +               wake_up_interruptible(&priv->cur_cmd->cmdwait_q);
> +       }
>        spin_unlock_irqrestore(&priv->driver_lock, flags);
> +
>        cancel_work_sync(&priv->cmd_work);
>        cancel_work_sync(&priv->tx_work);
>        while ((skb = skb_dequeue(&priv->bc_ps_buf)))
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
