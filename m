Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:56952 "EHLO iodev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbcFVSgc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 14:36:32 -0400
Date: Wed, 22 Jun 2016 15:36:23 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
Message-ID: <20160622183622.uo5avhsjzmnn6jgf@pirotess> (sfid-20160622_203636_268578_70B5619B)
References: <20160621001841.5383-1-ismael@iodev.co.uk>
 <57698F43.3050303@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xtabcvjwyzvlr722"
In-Reply-To: <57698F43.3050303@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xtabcvjwyzvlr722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 21/Jun/2016 21:02, Arend van Spriel wrote:
> On 21-06-16 02:18, Ismael Luceno wrote:
> > Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
> 
> A bit more description would be nice. I am actually wondering why you
> would be adding this. If I am not mistaken the AE1200 can not be handled
> by brcmfmac. Otherwise I am interested in a kernel log showing the
> device probe sequence with brcmfmac loaded with parameter debug=0x1416.

Log attached.

I was surprised it works without any tweaking.

There's quite a lot of unhelpful noise about those adapters, but not
much actual information, I couldn't find anything about those that
supposedly don't work, so I have no idea if it's just a different
firmware version or what did change (if anything).

--xtabcvjwyzvlr722
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="brcmfmac.log"

[90038.674869] brcmfmac: brcmfmac_module_init No platform data available.
[90038.674974] usbcore: registered new interface driver brcmfmac
[90061.138666] usb 1-1.1: new high-speed USB device number 11 using ehci-pci
[90061.227159] usb 1-1.1: New USB device found, idVendor=13b1, idProduct=0039
[90061.227171] usb 1-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[90061.227178] usb 1-1.1: Product: Linksys AE1200
[90061.227182] usb 1-1.1: Manufacturer: Cisco
[90061.227187] usb 1-1.1: SerialNumber: 000000000001
[90061.227887] brcmfmac: brcmf_get_module_param Enter, bus=1, chip=0, rev=0
[90061.228413] brcmfmac: brcmf_fw_get_firmwares_pcie enter: dev=1-1.1
[90061.549899] brcmfmac: brcmf_fw_request_code_done enter: dev=1-1.1
[90061.979427] brcmfmac: brcmf_attach Enter
[90061.979455] brcmfmac: brcmf_fweh_register event handler registered for PSM_WATCHDOG
[90061.979460] brcmfmac: brcmf_proto_attach Enter
[90061.979470] brcmfmac: brcmf_bus_change_state 0 -> 1
[90061.979567] brcmfmac: brcmf_bus_start 
[90061.979572] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
[90061.979575] brcmfmac: brcmf_add_if allocate netdev interface
[90061.979593] brcmfmac: brcmf_add_if  ==== pid:b2a, if:wlan%d (00:00:00:00:00:00) created ===
[90061.979597] brcmfmac: brcmf_bus_change_state 1 -> 1
[90061.980273] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cur_etheraddr, len=6
[90061.980278] brcmutil: data
[90061.980285] 00000000: 14 91 82 27 f0 cc                                ...'..
[90061.980894] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=98, len=68
[90061.980899] brcmutil: data
[90061.980907] 00000000: e4 14 00 00 47 43 00 00 00 70 05 72 03 00 00 00  ....GC...p.r....
[90061.980914] 00000010: 18 00 00 00 71 05 00 00 e4 14 00 00 23 15 00 00  ....q.......#...
[90061.980921] 00000020: 16 bc 5a 05 00 00 00 00 00 00 00 00 e3 a8 00 00  ..Z.............
[90061.980927] 00000030: 04 00 00 00 09 00 00 00 00 00 00 00 04 00 00 00  ................
[90061.981513] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=ver, len=256
[90061.981517] brcmutil: data
[90061.981522] 00000000: 77 6c 30 3a 20 4e 6f 76 20 33 30 20 32 30 31 31  wl0: Nov 30 2011
[90061.981525] 00000010: 20 31 37 3a 33 33 3a 34 32 20 76 65 72 73 69 6f   17:33:42 versio
[90061.981529] 00000020: 6e 20 35 2e 39 30 2e 31 38 38 2e 32 32 0a 00 00  n 5.90.188.22...
[90061.981533] 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[90061.981539] brcmf_c_preinit_dcmds: Firmware version = wl0: Nov 30 2011 17:33:42 version 5.90.188.22
[90061.981544] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mpc, len=4
[90061.981547] brcmutil: data
[90061.981550] 00000000: 01 00 00 00                                      ....
[90061.982252] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=join_pref, len=8
[90061.982255] brcmutil: data
[90061.982259] 00000000: 04 02 08 01 01 02 00 00                          ........
[90061.983504] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=event_msgs, len=18
[90061.983508] brcmutil: data
[90061.983513] 00000000: 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00  ......@.........
[90061.983516] 00000010: 00 00                                            ..
[90061.983521] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[90061.983524] brcmutil: data
[90061.983528] 00000000: 00 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00  ......@.........
[90061.983532] 00000010: 00 00                                            ..
[90061.984128] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=185, value=40
[90061.984768] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=187, value=40
[90061.985396] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=txbf, len=4
[90061.985403] brcmutil: data
[90061.985410] 00000000: 01 00 00 00                                      ....
[90061.986009] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.986665] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cap, len=256
[90061.986669] brcmutil: data
[90061.986673] 00000000: 73 74 61 20 74 6f 65 20 77 6d 65 20 38 30 32 2e  sta toe wme 802.
[90061.986677] 00000010: 31 31 64 20 38 30 32 2e 31 31 68 20 72 6d 20 63  11d 802.11h rm c
[90061.986681] 00000020: 71 61 20 63 63 78 20 63 61 63 20 61 6d 70 64 75  qa ccx cac ampdu
[90061.986685] 00000030: 20 61 6d 73 64 75 72 78 20 00 ff ff db 57 0f 81   amsdurx ....W..
[90061.986690] brcmfmac: brcmf_feat_firmware_capabilities [ sta toe wme 802.11d 802.11h rm cqa ccx cac ampdu amsdurx ]
[90061.987378] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.987383] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=pfn, len=4
[90061.987386] brcmutil: data
[90061.987390] 00000000: 00 00 00 00                                      ....
[90061.987395] brcmfmac: brcmf_feat_iovar_int_get PNO feature check failed: -23
[90061.988005] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.988010] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=wowl, len=4
[90061.988013] brcmutil: data
[90061.988017] 00000000: 00 00 00 00                                      ....
[90061.988022] brcmfmac: brcmf_feat_iovar_int_get WOWL feature check failed: -23
[90061.988668] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.988672] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=rsdb_mode, len=4
[90061.988676] brcmutil: data
[90061.988679] 00000000: 00 00 00 00                                      ....
[90061.988684] brcmfmac: brcmf_feat_iovar_int_get RSDB feature check failed: -23
[90061.989378] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.989383] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=tdls_enable, len=4
[90061.989386] brcmutil: data
[90061.989390] 00000000: 00 00 00 00                                      ....
[90061.989394] brcmfmac: brcmf_feat_iovar_int_get TDLS feature check failed: -23
[90061.990007] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.990012] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=mfp, len=4
[90061.990015] brcmutil: data
[90061.990019] 00000000: 00 00 00 00                                      ....
[90061.990023] brcmfmac: brcmf_feat_iovar_int_get MFP feature check failed: -23
[90061.990654] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.990659] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=pfn_macaddr, len=8
[90061.990662] brcmutil: data
[90061.990666] 00000000: 01 28 be 97 00 88 ff ff                          .(......
[90061.990845] brcmfmac: brcmf_fweh_register event handler registered for FIFO_CREDIT_MAP
[90061.990853] brcmfmac: brcmf_fweh_register event handler registered for BCMC_CREDIT_SUPPORT
[90061.990862] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=tlv, len=4
[90061.990867] brcmutil: data
[90061.990871] 00000000: 01 00 00 00                                      ....
[90061.991502] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=ampdu_hostreorder, len=4
[90061.991505] brcmutil: data
[90061.991509] 00000000: 01 00 00 00                                      ....
[90061.992255] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.992260] brcmfmac: brcmf_fws_init enabling AMPDU host-reorder failed
[90061.992879] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.992884] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=wlfc_mode, len=4
[90061.992887] brcmutil: data
[90061.992891] 00000000: 00 00 00 00                                      ....
[90061.992902] brcmfmac: brcmf_fws_macdesc_init enter: desc ffff880036e0acc0 ea=          (null), ifidx=0
[90061.992915] brcmfmac: brcmf_fws_init enabled bdcv2 tlv signaling [1]
[90061.992920] brcmfmac: brcmf_fws_macdesc_init enter: desc ffff880036e088c0 ea=14:91:82:27:f0:cc, ifidx=0
[90061.992925] brcmfmac: brcmf_fws_add_interface added MACIF:0
[90061.992942] brcmfmac: brcmf_alloc_vif allocating virtual interface (size=3880)
[90061.992965] brcmfmac: brcmf_fweh_register event handler registered for LINK
[90061.992969] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH_IND
[90061.992973] brcmfmac: brcmf_fweh_register event handler registered for DEAUTH
[90061.992977] brcmfmac: brcmf_fweh_register event handler registered for DISASSOC_IND
[90061.992981] brcmfmac: brcmf_fweh_register event handler registered for ASSOC_IND
[90061.992985] brcmfmac: brcmf_fweh_register event handler registered for REASSOC_IND
[90061.992989] brcmfmac: brcmf_fweh_register event handler registered for ROAM
[90061.992993] brcmfmac: brcmf_fweh_register event handler registered for MIC_ERROR
[90061.992997] brcmfmac: brcmf_fweh_register event handler registered for SET_SSID
[90061.993001] brcmfmac: brcmf_fweh_register event handler registered for PFN_NET_FOUND
[90061.993005] brcmfmac: brcmf_fweh_register event handler registered for IF
[90061.993009] brcmfmac: brcmf_fweh_register event handler registered for P2P_PROBEREQ_MSG
[90061.993013] brcmfmac: brcmf_fweh_register event handler registered for P2P_DISC_LISTEN_COMPLETE
[90061.993017] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_RX
[90061.993021] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_COMPLETE
[90061.993026] brcmfmac: brcmf_fweh_register event handler registered for ACTION_FRAME_OFF_CHAN_COMPLETE
[90061.993030] brcmfmac: brcmf_fweh_register event handler registered for ESCAN_RESULT
[90061.993710] brcmfmac: brcmf_fil_cmd_int_get ifidx=0, cmd=1, value=1
[90061.994380] brcmfmac: brcmf_fil_cmd_data_get ifidx=0, cmd=140, len=12
[90061.994384] brcmutil: data
[90061.994388] 00000000: 01 00 00 00 02 00 00 00 00 00 00 00              ............
[90061.995005] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.995010] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=vhtmode, len=4
[90061.995013] brcmutil: data
[90061.995017] 00000000: 00 00 00 00                                      ....
[90061.995654] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=nmode, len=4
[90061.995657] brcmutil: data
[90061.995661] 00000000: 01 00 00 00                                      ....
[90061.996254] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90061.996259] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=bw_cap, len=4
[90061.996262] brcmutil: data
[90061.996266] 00000000: 02 00 00 00                                      ....
[90061.996270] brcmfmac: brcmf_get_bwcap fallback to mimo_bw_cap info
[90061.996882] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=mimo_bw_cap, len=4
[90061.996886] brcmutil: data
[90061.996890] 00000000: 02 00 00 00                                      ....
[90061.996895] brcmfmac: brcmf_setup_wiphybands nmode=1, vhtmode=0, bw_cap=(1, 3)
[90061.997501] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=rxchain, len=4
[90061.997504] brcmutil: data
[90061.997508] 00000000: 03 00 00 00                                      ....
[90061.997512] brcmfmac: brcmf_setup_wiphybands nchain=2
[90061.999527] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspecs, len=1536
[90061.999531] brcmutil: data
[90061.999536] 00000000: 1f 00 00 00 01 2b 00 00 02 2b 00 00 03 2b 00 00  .....+...+...+..
[90061.999540] 00000010: 04 2b 00 00 05 2b 00 00 06 2b 00 00 07 2b 00 00  .+...+...+...+..
[90061.999544] 00000020: 08 2b 00 00 09 2b 00 00 0a 2b 00 00 0b 2b 00 00  .+...+...+...+..
[90061.999548] 00000030: 0c 2b 00 00 0d 2b 00 00 03 2e 00 00 04 2e 00 00  .+...+..........
[90062.000274] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.000279] brcmutil: data
[90062.000283] 00000000: 03 00 00 00                                      ....
[90062.000880] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.000883] brcmutil: data
[90062.000887] 00000000: 03 00 00 00                                      ....
[90062.001501] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.001505] brcmutil: data
[90062.001509] 00000000: 03 00 00 00                                      ....
[90062.002129] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.002134] brcmutil: data
[90062.002137] 00000000: 03 00 00 00                                      ....
[90062.002775] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.002779] brcmutil: data
[90062.002783] 00000000: 03 00 00 00                                      ....
[90062.003376] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.003380] brcmutil: data
[90062.003384] 00000000: 03 00 00 00                                      ....
[90062.004005] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.004009] brcmutil: data
[90062.004012] 00000000: 03 00 00 00                                      ....
[90062.004653] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.004656] brcmutil: data
[90062.004660] 00000000: 03 00 00 00                                      ....
[90062.005253] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.005257] brcmutil: data
[90062.005260] 00000000: 03 00 00 00                                      ....
[90062.005880] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.005884] brcmutil: data
[90062.005888] 00000000: 03 00 00 00                                      ....
[90062.006502] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.006505] brcmutil: data
[90062.006508] 00000000: 03 00 00 00                                      ....
[90062.007129] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.007133] brcmutil: data
[90062.007137] 00000000: 03 00 00 00                                      ....
[90062.007755] brcmfmac: brcmf_fil_bsscfg_data_get ifidx=0, bsscfgidx=0, name=per_chan_info, len=4
[90062.007759] brcmutil: data
[90062.007763] 00000000: 03 00 00 00                                      ....
[90062.007770] brcmfmac: brcmf_cfg80211_attach Registering custom regulatory
[90062.007880] brcmf_cfg80211_reg_notifier: not a ISO3166 code (0x30 0x30)
[90062.008664] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
[90062.008669] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=bw_cap, len=4
[90062.008672] brcmutil: data
[90062.008676] 00000000: 01 00 00 00                                      ....
[90062.008680] brcmfmac: brcmf_enable_bw40_2g fallback to mimo_bw_cap
[90062.008684] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=mimo_bw_cap, len=4
[90062.008687] brcmutil: data
[90062.008691] 00000000: 01 00 00 00                                      ....
[90062.011030] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=chanspecs, len=1536
[90062.011034] brcmutil: data
[90062.011039] 00000000: 12 00 00 00 03 2e 00 00 04 2e 00 00 05 2e 00 00  ................
[90062.011043] 00000010: 06 2e 00 00 07 2e 00 00 08 2e 00 00 09 2e 00 00  ................
[90062.011047] 00000020: 0a 2e 00 00 0b 2e 00 00 03 2d 00 00 04 2d 00 00  .........-...-..
[90062.011051] 00000030: 05 2d 00 00 06 2d 00 00 07 2d 00 00 08 2d 00 00  .-...-...-...-..
[90062.011060] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=obss_coex, len=4
[90062.011063] brcmutil: data
[90062.011067] 00000000: ff ff ff ff                                      ....
[90062.011773] brcmfmac: brcmf_fweh_activate_events enable event SET_SSID
[90062.011778] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH
[90062.011782] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH_IND
[90062.011785] brcmfmac: brcmf_fweh_activate_events enable event ASSOC_IND
[90062.011789] brcmfmac: brcmf_fweh_activate_events enable event REASSOC_IND
[90062.011793] brcmfmac: brcmf_fweh_activate_events enable event DISASSOC_IND
[90062.011797] brcmfmac: brcmf_fweh_activate_events enable event LINK
[90062.011801] brcmfmac: brcmf_fweh_activate_events enable event MIC_ERROR
[90062.011804] brcmfmac: brcmf_fweh_activate_events enable event ROAM
[90062.011809] brcmfmac: brcmf_fweh_activate_events enable event PFN_NET_FOUND
[90062.011813] brcmfmac: brcmf_fweh_activate_events enable event PSM_WATCHDOG
[90062.011817] brcmfmac: brcmf_fweh_activate_events enable event IF
[90062.011821] brcmfmac: brcmf_fweh_activate_events enable event P2P_DISC_LISTEN_COMPLETE
[90062.011825] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_COMPLETE
[90062.011829] brcmfmac: brcmf_fweh_activate_events enable event ESCAN_RESULT
[90062.011833] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_OFF_CHAN_COMPLETE
[90062.011837] brcmfmac: brcmf_fweh_activate_events enable event P2P_PROBEREQ_MSG
[90062.011841] brcmfmac: brcmf_fweh_activate_events enable event FIFO_CREDIT_MAP
[90062.011845] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_RX
[90062.011850] brcmfmac: brcmf_fweh_activate_events enable event BCMC_CREDIT_SUPPORT
[90062.011853] brcmfmac: brcmf_fweh_activate_events enable event IF
[90062.011858] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[90062.011861] brcmutil: data
[90062.011865] 00000000: 61 15 0b 00 02 02 c0 10 60 0d 00 00 00 00 00 80  a.......`.......
[90062.011869] 00000010: 00 00                                            ..
[90062.012501] brcmfmac: brcmf_btcoex_attach enter
[90062.012507] brcmfmac: brcmf_fweh_activate_events enable event SET_SSID
[90062.012511] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH
[90062.012514] brcmfmac: brcmf_fweh_activate_events enable event DEAUTH_IND
[90062.012518] brcmfmac: brcmf_fweh_activate_events enable event ASSOC_IND
[90062.012522] brcmfmac: brcmf_fweh_activate_events enable event REASSOC_IND
[90062.012525] brcmfmac: brcmf_fweh_activate_events enable event DISASSOC_IND
[90062.012529] brcmfmac: brcmf_fweh_activate_events enable event LINK
[90062.012533] brcmfmac: brcmf_fweh_activate_events enable event MIC_ERROR
[90062.012537] brcmfmac: brcmf_fweh_activate_events enable event ROAM
[90062.012541] brcmfmac: brcmf_fweh_activate_events enable event PFN_NET_FOUND
[90062.012544] brcmfmac: brcmf_fweh_activate_events enable event PSM_WATCHDOG
[90062.012548] brcmfmac: brcmf_fweh_activate_events enable event IF
[90062.012552] brcmfmac: brcmf_fweh_activate_events enable event P2P_DISC_LISTEN_COMPLETE
[90062.012556] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_COMPLETE
[90062.012560] brcmfmac: brcmf_fweh_activate_events enable event ESCAN_RESULT
[90062.012564] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_OFF_CHAN_COMPLETE
[90062.012569] brcmfmac: brcmf_fweh_activate_events enable event P2P_PROBEREQ_MSG
[90062.012573] brcmfmac: brcmf_fweh_activate_events enable event FIFO_CREDIT_MAP
[90062.012577] brcmfmac: brcmf_fweh_activate_events enable event ACTION_FRAME_RX
[90062.012581] brcmfmac: brcmf_fweh_activate_events enable event BCMC_CREDIT_SUPPORT
[90062.012584] brcmfmac: brcmf_fweh_activate_events enable event IF
[90062.012589] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=event_msgs, len=18
[90062.012592] brcmutil: data
[90062.012596] 00000000: 61 15 0b 00 02 02 c0 10 60 0d 00 00 00 00 00 80  a.......`.......
[90062.012633] 00000010: 00 00                                            ..
[90062.014137] brcmfmac: brcmf_net_attach Enter, bsscfgidx=0 mac=14:91:82:27:f0:cc
[90062.014596] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0
[90062.014655] brcmfmac: brcmf_net_attach wlan1: Broadcom Dongle Host Driver
[90062.014836] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0
[90062.101404] usb 1-1.1 wlan122: renamed from wlan1
[90062.113795] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0
[90062.114073] udevd[27127]: renamed network interface wlan1 to wlan122
[90062.114092] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0
[90062.114120] usb 1-1.1 wlan3: renamed from wlan122
[90062.125714] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0
[90062.125945] udevd[27127]: renamed network interface wlan122 to wlan3
[90062.140979] brcmfmac: brcmf_netdev_get_stats Enter, bsscfgidx=0

--xtabcvjwyzvlr722--
